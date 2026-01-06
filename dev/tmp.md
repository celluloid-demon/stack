# Tmp

Below is a quick‑start guide to the **de‑facto standard** that the homelab community is using in 2024 to see exactly how many megabytes each Docker container (or “service”) is eating from your ISP pipe – **Prometheus + cAdvisor + Grafana** (or the one‑click alternative **Netdata**).  
Both stacks give you:

| Feature | Prometheus‑cAdvisor‑Grafana | Netdata |
|---------|------------------------------|---------|
| Persistent time‑series storage (Prometheus) | ✅ | ✅ (built‑in) |
| Per‑container **network‑in / network‑out** counters | ✅ (via cAdvisor) | ✅ |
| Auto‑discovery of new containers | ✅ (service‑discovery) | ✅ |
| Rich, shareable dashboards | ✅ (Grafana) | ✅ (Netdata dashboards) |
| Low‑maintenance, single‑node friendly | ✅ (few services) | ✅ (single container) |
| Alerting (e.g., “you’re 80 % of your monthly cap”) | ✅ (Prometheus Alertmanager) | ✅ (Netdata alerts) |
| Export to external monitoring (InfluxDB, Loki, etc.) | ✅ | ✅ |

If you only need a **quick, zero‑config view**, spin up Netdata. If you already run Prometheus for other metrics (CPU, memory, home‑assistant, etc.) or you want sophisticated alerts and long‑term retention, add cAdvisor to your Prometheus scrape list and build a Grafana dashboard.

---

## 1️⃣ The “prometheus‑cAdvisor‑grafana” stack (the community favourite)

### 1.1 Architecture diagram

```
+-----------------+          +-------------------+          +-----------------+
|  Docker host    |          |  Prometheus       |          |  Grafana        |
|  (eth0)         | <--->    |  (scrapes        )| <--->    |  (queries       )|
|                 |          |   cAdvisor)       |          |   Prometheus)   |
+-----------------+          +-------------------+          +-----------------+
          ^                         ^   ^                     ^
          |                         |   |                     |
          |                         |   +--- cAdvisor metrics|
          |                         |                         |
          +--- iptables counters (optional, for ISP‑wide cap) 
```

* **cAdvisor** (`google/cadvisor:latest`) runs on the host, reads the Docker **cgroup** information for every container, and exposes a Prometheus endpoint (`/metrics`) that includes:
  * `container_network_receive_bytes_total`
  * `container_network_transmit_bytes_total`
  * … plus per‑interface breakdowns if you enable the `--docker_only` flag.
* **Prometheus** scrapes that endpoint every 15 s (or whatever you like) and stores the raw counters.
* **Grafana** visualises the data with a few community‑contributed dashboards (see links below) and lets you build “monthly per‑service usage” graphs.

### 1.2 Minimal docker‑compose

Create a file called `docker-compose.yml` in a folder on your host (e.g., `~/monitoring`) and paste:

```yaml
version: "3.9"

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    volumes:
      - ./prometheus:/etc/prometheus
      - prometheus-data:/prometheus
    command:
      - "--config.file=/etc/prometheus/prometheus.yml"
      - "--storage.tsdb.retention.time=90d"   # keep 3 months of data
    ports:
      - "9090:9090"
    restart: unless-stopped

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    privileged: true          # needed to read cgroup stats
    devices:
      - "/dev/kmsg:/dev/kmsg"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    ports:
      - "8080:8080"            # optional UI
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    depends_on:
      - prometheus
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=changeme   # change ASAP
    volumes:
      - grafana-data:/var/lib/grafana
    ports:
      - "3000:3000"
    restart: unless-stopped

volumes:
  prometheus-data:
  grafana-data:
```

#### 1.2.1 Prometheus config (`prometheus/prometheus.yml`)

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: "cadvisor"
    static_configs:
      - targets: ["cadvisor:8080"]
```

> **Tip** – If you already have a Prometheus instance for other services, just add the `cadvisor` job to its config; you don’t need a second Prometheus.

#### 1.2.2 Start it

```bash
mkdir -p ~/monitoring/prometheus
# copy the prometheus.yml into that folder
docker compose up -d
```

You’ll now have:
* Prometheus UI → `http://<host_ip>:9090`
* Grafana UI → `http://<host_ip>:3000` (login admin / changeme)

### 1.3 Grafana dashboard – “Docker‑Network‑Usage”

The community maintains a **ready‑made dashboard** that already does the heavy lifting:

* **Dashboard ID = 893** – “Docker Host Overview”
* **Dashboard ID = 1225** – “Docker Container Network Traffic”

You can import them directly:

1. Log into Grafana → **+** → **Import**.  
2. Paste the ID (e.g., `1225`) and click **Load**.  
3. Set the datasource to the Prometheus instance you just started.  

The dashboard will show you per‑container `rx_bytes` and `tx_bytes` as line graphs, as well as **total‑monthly** counters that you can sum up to see how close you are to your ISP cap.

#### 1.3.1 Building a “monthly usage” panel

If you want a custom panel that resets each month, add a **PromQL** query like:

```promql
sum by (container_label_com_docker_compose_service) (
  rate(container_network_receive_bytes_total{job="cadvisor"}[5m])
) * 3600 * 24 * 30
```

Replace the `container_label_*` selector with the label you use to name your services (most people use `com.docker.compose.service`).

### 1.4 Alerting – “You’ve used 80 % of your plan”

Add an Alertmanager rule (in `prometheus/alert.rules.yml`):

```yaml
groups:
  - name: internet_usage
    rules:
      - alert: HighMonthlyTraffic
        expr: |
          sum by (container_label_com_docker_compose_service) (
            increase(container_network_transmit_bytes_total{job="cadvisor"}[30d])
          ) > 0.8 * 500 * 1024 * 1024 * 1024   # 0.8 × 500 GB (example)
        for: 1h
        labels:
          severity: warning
        annotations:
          summary: "Container {{ $labels.container_label_com_docker_compose_service }} used >80 % of monthly 500 GB cap"
          description: "Current 30‑day traffic: {{ $value | humanize1024 }} bytes"
```

* Adjust the `500 GB` to match your ISP plan.  
* Hook Alertmanager to a webhook, Discord, or email – the homelab community loves a little **Mattermost** or **Gotify** integration.

---

## 2️⃣ The “single‑container Netdata” alternative (quick‑start)

If you want **zero‑maintenance**, just drop a Netdata container on the same host:

```yaml
version: "3.9"
services:
  netdata:
    image: netdata/netdata:latest
    container_name: netdata
    hostname: ${HOSTNAME}
    cap_add:
      - SYS_PTRACE
    security_opt:
      - apparmor=unconfined
    volumes:
      - /etc/passwd:/host/etc/passwd:ro
      - /etc/group:/host/etc/group:ro
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - netdata-data:/var/lib/netdata
    ports:
      - "19999:19999"
    restart: unless-stopped

volumes:
  netdata-data:
```

Netdata automatically discovers Docker containers and adds a **“Network I/O”** chart per‑container. It also ships a **monthly “traffic”** chart that you can export to CSV or set a **health alarm** (e.g., > 80 % of your plan).  

*Pros*:  
* One container, one UI, auto‑updates.  
* Real‑time per‑second granularity (good for spotting spikes).  

*Cons*:  
* Retention is limited (by default 2 months, though you can enable the `netdata streaming` or external DB).  
* Alerting isn’t as flexible as Prometheus+Alertmanager.

---

## 3️⃣ Optional Enhancements (what the community adds on top)

| Enhancement | Why it’s useful | How to add it |
|-------------|----------------|---------------|
| **InfluxDB + Telegraf** | If you already run Home Assistant + InfluxDB, Telegraf’s `docker` input feeds the same counters into the same DB, letting you reuse existing Grafana dashboards. | Add a `telegraf` service with `[[inputs.docker]]` and point it at InfluxDB. |
| **iptables accounting** | If you need a **global ISP‑wide counter** (including traffic that bypasses Docker, like host updates), use `iptables -L -v -n -x` rules per container IP and scrape those counters with a custom exporter (`iptables_exporter`). | Create a rule per container subnet and expose via `node_exporter` textfile collector. |
| **Cilium + Hubble UI** | For deep‑packet inspection (e.g., “which container is talking to which external domain?”) and per‑service bandwidth throttling. | Deploy Cilium as a CNI and enable Hubble; then add the Hubble UI as a Grafana datasource. |
| **Traefik + Prometheus metrics** | If all inbound traffic goes through a reverse‑proxy, you can also track **per‑router** bytes (useful for multi‑tenant setups). | Enable `--metrics.prometheus=true` in Traefik and add a scrape job. |
| **Daily CSV export** | For offline budgeting (e.g., import into Google Sheets). | Use `prometheus-to-csv` or a simple `cron` job that runs `curl -G http://localhost:9090/api/v1/query_range?...` and appends to a file. |

---

## 4️⃣ Step‑by‑step checklist for a “first‑time homelab user”

1. **Pick a stack** –  
   *If you already have Prometheus/Grafana → go with the cAdvisor add‑on.*  
   *If you want something that “just works” → Netdata.*

2. **Deploy the stack** (docker‑compose file above).  
   - Verify `docker ps` shows three containers running.  
   - Visit `http://<host>:3000` (Grafana) and log in.

3. **Import the dashboard** (ID 1225).  
   - Adjust the `container_label_com_docker_compose_service` selector if you use a different label scheme.

4. **Create a “monthly cap” variable** in Grafana:  
   - Settings → Variables → **Add** → Name: `monthly_cap_gb`, Type: **Constant**, Value: `500` (or your plan).  
   - Use `$monthly_cap_gb` in your alert expressions.

5. **Set up alerts** (Prometheus → Alertmanager → your preferred channel).  
   - Test by temporarily lowering the threshold to a few megabytes.

6. **(Optional) Export to InfluxDB** if you already have an InfluxDB/Grafana stack – just add the Telegraf container.

7. **Document the process** – the homelab community loves a good `README.md` in the repo, so future you (or a friend) can spin it up on a fresh server.

---

## 5️⃣ Quick‑reference links (the ones the community keeps bookmarking)

| Resource | Why it matters |
|----------|----------------|
| **cAdvisor GitHub** – <https://github.com/google/cadvisor> | Official container, no extra deps. |
| **Prometheus Docker Compose Example** – <https://github.com/prometheus/prometheus/blob/main/documentation/examples/prometheus-docker-compose.yml> |
| **Grafana Dashboard 1225** – <https://grafana.com/grafana/dashboards/1225> | “Docker Container Network Traffic”. |
| **Netdata Docs – Docker Monitoring** – <https://learn.netdata.cloud/docs/agent/collectors/docker/> |
| **Telegraf Docker Input** – <https://github.com/influxdata/telegraf/blob/master/plugins/inputs/docker/README.md> |
| **Prometheus Alertmanager** – <https://prometheus.io/docs/alerting/latest/alertmanager/> |
| **Home‑Lab‑OS Community Wiki (Networking)** – <https://github.com/awesome-selfhosted/awesome-selfhosted#network-monitoring> |

---

## TL;DR

**The community’s go‑to answer:**  
> **Deploy `cAdvisor` + Prometheus + Grafana (or the one‑click Netdata container) and use the ready‑made “Docker Container Network Traffic” Grafana dashboard.**  

That stack gives you per‑service inbound/outbound bytes, automatic persistence, alerting for ISP caps, and integrates nicely with the other observability tools most homelabbers already run.

Give it a try, and you’ll have a beautiful chart that tells you exactly which of your self‑hosted apps is eating up your 500 GB/month plan. Happy monitoring! 🚀

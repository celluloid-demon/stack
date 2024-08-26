HAS Reverse Proxy Configuration
===============================

Source: https://www.home-assistant.io/integrations/http/

```text

When using a reverse proxy, you will need to enable the use_x_forwarded_for and trusted_proxies options. Requests from reverse proxies will be blocked if these options are not set.

```

```yml

# Example configuration.yaml entry
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 10.0.0.200      # Add the IP address of the proxy server
    - 172.30.33.0/24  # You may also provide the subnet mask

```

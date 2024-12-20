#!/bin/bash

from_pacman_install_packages() {

    func="from_pacman_install_packages"

    [ $DEBUG -eq 1 ] && echo $func

    if [ $OS = STEAMOS ]; then

        sudo steamos-readonly disable

        sudo pacman-key --init
        sudo pacman-key --populate archlinux
        sudo pacman-key --populate holo

        # WARNING: Steamdeck rootfs partition only has ~5G allocated for it, be VERY judicious with what you add here to avoid bricking your system!

        # NOTE: Arch doesn't use service scripts, so 'null' is the answer to your question. However, since you want to use vmware, it needs to put it's scripts somewhere, and /etc/init.d is as good a place as any.

        PACKAGES="byobu krfb tldr"
        PACKAGES_AUR="base-devel go"
        PACKAGES_VMWARE="dkms libaio gcr fuse2 gtkmm linux-neptune-headers ncurses libcanberra pcsclite"

        # NOTE: The vmware-workstation PKGBUILD contains instructions on how to avoid the package having a dependency on vmware-keymaps.

        # WARNING: Steam Deck repos might not ship the latest linux headers matching your kernel version, you can download the up-to-date version of your headers for vmware manually and install via `sudo pacman -U <linux_headers_archive>`

        # WARNING: To download headers manually:
        # WARNING: https://steamdeck-packages.steamos.cloud/archlinux-mirror/jupiter-main/os/x86_64/
        # WARNING: source:
        # WARNING: https://www.reddit.com/r/SteamDeck/comments/y6uudu/installing_kernel_headers/

    #     PACKAGES_KVM="dnsmasq libvirt qemu-base virt-manager"
    #     PACKAGES_KVM_TPM="swtpm"

        sudo pacman --needed --noconfirm -Syu $PACKAGES $PACKAGES_AUR $PACKAGES_VMWARE

        sudo steamos-readonly enable

    fi

}

from_flathub_install_packages() {

    func="from_flathub_install_packages"

    [ $DEBUG -eq 1 ] && echo $func

    if [ $OS = FEDORA ] || [ $OS = UBUNTU_WSL ]; then

        flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    fi

    # WARNING: Ran into issues with these
    FLATPAKS_PROBLEM="

    com.play0ad.zeroad
    org.kde.kmymoney

    "

    FLATPAKS_COMMON="

    com.github.flxzt.rnote
    com.github.jeromerobert.pdfarranger
    com.github.tchx84.Flatseal
    com.google.Chrome
    com.toolstack.Folio

    de.haeckerfelix.Shortwave
    fr.handbrake.ghb
    io.mpv.Mpv
    io.podman_desktop.PodmanDesktop
    net.ankiweb.Anki
    net.mediaarea.MediaInfo

    org.audacityteam.Audacity
    org.bunkus.mkvtoolnix-gui
    org.gnome.Lollypop
    org.libreoffice.LibreOffice
    org.qbittorrent.qBittorrent

    "

    FLATPAKS_VIRT="

    org.gnome.Boxes

    "

    FLATPAKS_GAMING="

    com.valvesoftware.SteamLink
    net.davidotek.pupgui2
    net.lutris.Lutris
    org.openmw.OpenMW
    org.wesnoth.Wesnoth/x86_64/stable

    "

    FLATPAKS_GRAPHICS="

    io.github.OpenToonz
    org.blender.Blender
    org.freecadweb.FreeCAD
    org.gimp.GIMP

    "

    FLATPAKS_KDE="

    org.kde.kdenlive
    org.kde.krita
    org.kde.kstars
    org.kde.ksudoku
    org.kde.skanpage

    "

    FLATPAKS_STEAMOS_ONLY="

    org.mozilla.firefox
    org.kde.kcalc
    org.kde.kolourpaint
    org.kde.konversation
    org.kde.kpat
    org.kde.kwalletmanager5

    "

    # (NOTE: List of snaps not available as flatpaks / not performant in target environment)
    FLATPAKS_UBUNTU_WSL_SUPPLEMENTARY="

    com.github.tchx84.Flatseal
    com.google.Chrome
    io.podman_desktop.PodmanDesktop

    "

#   (note: discord flatpak deprecated in favor of "full" linux version from website, with screen-sharing, etc)
#   flatpak install flathub com.discordapp.Discord -y

    if [ $OS = FEDORA ]; then

        flatpak update  -y --user
        flatpak install -y --user flathub \
                                            $FLATPAKS_COMMON \
                                            $FLATPAKS_GAMING \
                                            $FLATPAKS_GRAPHICS \
                                            $FLATPAKS_KDE \
                                            $FLATPAKS_VIRT

    elif [ $OS = STEAMOS ]; then

        # NOTE: steamOS installs flatpaks to user's home directory by default
        flatpak update  -y
        flatpak install -y flathub \
                                        $FLATPAKS_COMMON \
                                        $FLATPAKS_GAMING \
                                        $FLATPAKS_GRAPHICS \
                                        $FLATPAKS_KDE \
                                        $FLATPAKS_STEAMOS_ONLY \
                                        $FLATPAKS_VIRT

    elif [ $OS = UBUNTU_WSL ]; then

        flatpak update  -y
        flatpak install -y flathub $FLATPAKS_UBUNTU_WSL_SUPPLEMENTARY

    fi

}

set_password() {

    func="set_password"

    [ $DEBUG -eq 1 ] && echo $func

    if [ $OS = FEDORA ]; then

        password_status=$(sudo passwd --status "$USER" | awk '{print $2}')

        if [ "$password_status" = "PS" ]; then FLAG_password_set=1; fi

    elif [ $OS = FEDORA_WSL ]; then

        password_status=$(sudo passwd --status "$USER" | awk '{print $2}')

        if [ "$password_status" = "PS" ]; then FLAG_password_set=1; fi

    elif [ $OS = STEAMOS ]; then

        password_status=$(passwd --status | awk '{print $2}')

        if [ "$password_status" = "P" ]; then FLAG_password_set=1; fi

    elif [ $OS = UBUNTU_WSL ]; then

        password_status=$(passwd --status "$USER" | awk '{print $2}')

        if [ "$password_status" = "P" ]; then FLAG_password_set=1; fi

    fi

    if [ $FLAG_password_set -eq 0 ]; then

        passwd

    fi

}

install_steamos_tweak_cpu() {

    func="install_steamos_tweak_cpu"

    [ $DEBUG -eq 1 ] && echo $func

    if [ $OS = STEAMOS ]; then

        service_file="/etc/systemd/system/cpu_performance.service"

        if [ -f "$service_file" ]; then

            FLAG_did_tweak_cpu=1

        fi

    fi

    # Unfortunately, even the newest (at the time of writing) SteamOS 3.5 release still ships with a CPU governor called schedutil, which is less than desirable if you want a rather even & consistent frame-pacing, because of the erratic downclocking behavior it has become famous for in Linux enthusiast circles.

    # On the other hand, the performance governor does exactly what it says on the tin:

    # "It always requests the highest performance state of the CPU that is available, thus either preventing or at the very least reducing many of the dreaded frame-time spikes plaguing the schedutil governor."

    # But what about my temperatures — is it going to melt my Steam Deck ???

    # The short answer is: No, it won’t!

    # The slighty longer answer:

    # All modern CPUs (including the Steam Deck’s AMD Zen 2 architecture) have so-called “sleep states”, which allow the CPU to almost completely power-off certain parts of individual cores at any given opportunity, which ensures they save the most amount of energy & heat, way more so than what the simplistic downclocking strategy could ever hope to achieve.

    # source: https://medium.com/@a.b.t./here-are-some-possibly-useful-tweaks-for-steamos-on-the-steam-deck-fcb6b571b577

    if [ $OS = STEAMOS ] && [ $FLAG_did_tweak_cpu -eq 0 ]; then

cat << EOF | sudo tee /etc/systemd/system/cpu_performance.service
[Unit]
Description=CPU performance governor
[Service]
Type=oneshot
ExecStart=/usr/bin/cpupower frequency-set -g performance
[Install]
WantedBy=multi-user.target
EOF

        sudo systemctl daemon-reload
        sudo systemctl enable cpu_performance.service

        FLAG_restart_required=1

    fi

}

install_steamos_tweak_dragon() {

    func="install_steamos_tweak_dragon"

    [ $DEBUG -eq 1 ] && echo $func

    if [ $OS = STEAMOS ]; then

        grub_config=$(cat /etc/default/grub)

        if grep -q "mitigations=off" <<< "$grub_config"; then

            FLAG_did_tweak_dragon=1

        fi

    fi

    # Disabling CPU security flaw mitigations

    # (a.k.a. Here Be Dragons!)

    # Let me start by explicitly stating that the change described in this segment has the hypothetical potential of becoming a security risk for SteamOS, so caveat emptor!

    # Having said that, I am limiting my personal risk exposure by only disabling the CPU mitigations when my Steam Deck is in offline mode.

    # This has the added benefit of preserving battery life, because an active WLAN/WiFi connection requires energy to operate, obviously.

    # And since I exclusively play offline single-player games which don’t require an active Internet connection anyway, disabling the costly CPU mitigations is viable for me personally.

    # Now, disabling the security flaw mitigations can boost the performance of SteamOS quite a bit on Steam Deck’s AMD Zen 2 CPU architecture, especially with the most recent hardware bug named Retbleed.

    # For a good demonstration of the current penalty and the potential performance uplift by deactivating the mitigations on Zen 2 CPUs, I can once again point you towards this benchmark done by Phoronix:

    # https://www.phoronix.com/review/amd-3950x-retbleed

    # Thus, if you personally are comfortable with running an operating system with a known security risk that theoretically could be exploited, then the following command will have you covered:

    # source: https://medium.com/@a.b.t./here-are-some-possibly-useful-tweaks-for-steamos-on-the-steam-deck-fcb6b571b577

    if [ $OS = STEAMOS ] && [ $FLAG_did_tweak_dragon -eq 0 ]; then

        sudo sed -i 's/\bGRUB_CMDLINE_LINUX_DEFAULT="\b/&mitigations=off /' /etc/default/grub

        sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg

        FLAG_restart_required=1

    fi

}

install_steamos_tweak_io_scheduler() {

    func="install_steamos_tweak_io_scheduler"

    [ $DEBUG -eq 1 ] && echo $func

    if [ $OS = STEAMOS ]; then

        rules_file="/etc/udev/rules.d/64-ioschedulers.rules"

        if [ -f "$rules_file" ]; then

            FLAG_did_tweak_io_scheduler=1

        fi

    fi

    # An I/O-scheduler tries to efficiently balance both read & write performance as well as the latency of access times to block devices such as a NVMe SSD, eMMC storage or even a microSD card.

    # SteamOS has three different I/O-schedulers to choose from. [Technically, there’s also the option of having no I/O-scheduler at all.]

    # By default, it uses mq-deadline, which is a port of the older deadline scheduler from a time when the block subsystem of the Linux kernel only had a single queue to work with, towards the more efficient multi-queue design of contemporary Linux.

    # The other two remaining options are called bfq & kyber:

    # BFQ has a strict focus on providing low-latency I/O-operations even under heavy loads; however, that achievement comes at the cost of reduced throughput performance, in particular when it comes to write speeds.

    # Kyber on the other hand was developed by Facebook for use on their high-end storage servers. Therefore, it has a rather simple design that is light on the strain it puts on the CPU.

    # In practice, I found Kyber to be the best all-rounder among the three, since it allows the diverse storage devices to both reach the maximum capacity of their respective throughput (i.e. read & write) speeds while at the same time still providing low enough latencies even among high I/O pressure.

    # source: https://medium.com/@a.b.t./here-are-some-possibly-useful-tweaks-for-steamos-on-the-steam-deck-fcb6b571b577

    if [ $OS = STEAMOS ] && [ $FLAG_did_tweak_io_scheduler -eq 0 ]; then

cat << EOF | sudo tee /etc/udev/rules.d/64-ioschedulers.rules
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="kyber"
ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"
EOF

        FLAG_restart_required=1

    fi

}

install_steamos_tweak_memory() {

    func="install_steamos_tweak_memory"

    [ $DEBUG -eq 1 ] && echo $func

    if [ $OS = STEAMOS ]; then

        conf_file="/etc/security/limits.d/memlock.conf"

        if [ -f "$conf_file" ]; then

            FLAG_did_tweak_memory=1

        fi

    fi

    # This is an optimization which will especially help RPCS3, which is an emulator for Sony’s PlayStation 3 console.

    # In fact, when you run RPCS3 from a terminal on Linux, it will complain with the following message:

    # "Warning message: Failed to set RLIMIT_MEMLOCK size to 2 GiB. Try to update your system configuration."

    # By default, the Linux kernel sets this particular value to just 64KiB, which is the maximum amount of memory the kernel will lock within a single operation, and the following is what one of the main developers of RPCS3 had to say on the topic:

    # "64K is some outdated over-precautious limitation from 1990’s era."

    # Well, okay then, let’s increase our limit to 2GiB in order to advance into the 2020’s era:

    # source: https://medium.com/@a.b.t./here-are-some-possibly-useful-tweaks-for-steamos-on-the-steam-deck-fcb6b571b577

    if [ $OS = STEAMOS ] && [ $FLAG_did_tweak_memory -eq 0 ]; then

cat << EOF | sudo tee /etc/security/limits.d/memlock.conf
* hard memlock 2147484
* soft memlock 2147484
EOF

        FLAG_restart_required=1

    fi

}

install_steamos_tweak_watchdog() {

    func="install_steamos_tweak_watchdog"

    [ $DEBUG -eq 1 ] && echo $func

    if [ $OS = STEAMOS ]; then

        grub_config=$(cat /etc/default/grub)

        if grep -q "nowatchdog nmi_watchdog=0" <<< "$grub_config"; then

            FLAG_did_tweak_watchdog=1

        fi

    fi

    # A watchdog timer in computer terminology is either a piece of hardware or software which can be used for both detection & recovery of malfunctions.

    # These are critical components for enterprise devices in order to ensure that they meet high-availability demands, however the Steam Deck is none of that.

    # Therefore, disabling the watchdog timers has no ill-effects; to the contrary, it can actually help the Steam Deck by not generating any interrupt requests of its own.

    # source: https://medium.com/@a.b.t./here-are-some-possibly-useful-tweaks-for-steamos-on-the-steam-deck-fcb6b571b577

    if [ $OS = STEAMOS ] && [ $FLAG_did_tweak_watchdog -eq 0 ]; then

        sudo sed -i 's/\bGRUB_CMDLINE_LINUX_DEFAULT="\b/&nowatchdog nmi_watchdog=0 /' /etc/default/grub

        sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg

        FLAG_restart_required=1

    fi

}

install_steamos_tweak_mglru() {

    func="install_steamos_tweak_mglru"

    [ $DEBUG -eq 1 ] && echo $func

    if [ $OS = STEAMOS ]; then

        conf_file="/etc/tmpfiles.d/mglru.conf"

        if [ -f "$conf_file" ]; then

            FLAG_did_tweak_mglru=1

        fi

    fi

    # This is one of the most recent additions to the upstream Linux kernel, literally just merged for the 6.1 LTS (Long-Term Support) version which the SteamOS 3.5 release switched towards over the 5.13 kernel used previously.

    # It is a feature developed by a Google engineer to dramatically improve upon the memory management of Linux, and is already in use on both Android & ChromeOS.

    # However, the upstream kernel doesn’t enable this functionality by default, yet.

    # source: https://medium.com/@a.b.t./here-are-some-possibly-useful-tweaks-for-steamos-on-the-steam-deck-fcb6b571b577

    if [ $OS = STEAMOS ] && [ $FLAG_did_tweak_mglru -eq 0 ]; then

cat << EOF | sudo tee /etc/tmpfiles.d/mglru.conf
w /sys/kernel/mm/lru_gen/enabled - - - - 7
w /sys/kernel/mm/lru_gen/min_ttl_ms - - - - 0
EOF

        FLAG_restart_required=1

    fi

}

configure-kvm() {

    func="placeholder"

    [ $DEBUG -eq 1 ] && echo $func

    config="/etc/libvirt/libvirtd.conf"

    sudo sed -i 's/#\s*unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' "$config"
    sudo sed -i 's/#\s*unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/' "$config"

    sudo usermod -a -G libvirt $(whoami)

    sudo systemctl start  libvirtd.service
    sudo systemctl start  virtlogd.service
    sudo systemctl enable libvirtd.service
    sudo systemctl enable virtlogd.service

    sudo virsh net-start     default
    sudo virsh net-autostart default

    FLAG_restart_required=1

}

check-kvm-config() {

    func="placeholder"

    [ $DEBUG -eq 1 ] && echo $func

    config="/etc/libvirt/libvirtd.conf"
    search="#[[:space:]]*unix_sock_rw_perms = \"0770\""

    # Read: If comment "# unix_sock_rw_perms..." found, assume config was successfully edited
    if ! grep -qE "$search" "$config"; then

        FLAG_kvm_configured=1

    fi

}

check-emudeck() {

    func="placeholder"

    [ $DEBUG -eq 1 ] && echo $func

    emudeck="EmuDeck.desktop"

    if [ -f "${APPLICATIONS}/EmuDeck/${emudeck}" ]; then

        FLAG_emudeck_installed=1

    fi

}

from-web-get-emudeck-installer() {

    func="placeholder"

    [ $DEBUG -eq 1 ] && echo $func

    # grabbing essentially another bootstrap file, we don't need to get too fancy

    url="https://www.emudeck.com/EmuDeck.desktop"

    cd "${HOME}/Desktop" && wget "$url"

}

from_web_install_discord() {

    func="from_web_install_discord"

    [ $DEBUG -eq 1 ] && echo $func

    if [ -d "${APPLICATIONS}/Discord" ]; then

        FLAG_discord_installed=1

    fi

    if [ $FLAG_discord_installed -eq 1 ]; then

        do_nothing=

    elif [ $OS = FEDORA ] || [ $OS = STEAMOS ]; then

        url="https://discord.com/api/download?platform=linux&format=tar.gz"

        wget -O "${HOME}/Downloads/discord.tar.gz" "$url"

        tar -xvzf "${HOME}/Downloads/discord.tar.gz" -C "${APPLICATIONS}/"

        desktop_file="discord.desktop"

        mkdir -p "${HOME}/.local/share/applications"

        cp "${APPLICATIONS}/Discord/${desktop_file}" "${HOME}/.local/share/applications/"

        if [ $OS = FEDORA ]; then
        sed -i 's|^Exec=.*|Exec=/home/jonathan/Applications/Discord/Discord|g'     "${HOME}/.local/share/applications/${desktop_file}"
        sed -i 's|^Icon=.*|Icon=/home/jonathan/Applications/Discord/discord.png|g' "${HOME}/.local/share/applications/${desktop_file}"
        fi

        if [ $OS = STEAMOS ]; then
        sed -i 's|^Exec=.*|Exec=/home/deck/Applications/Discord/Discord|g'     "${HOME}/.local/share/applications/${desktop_file}"
        sed -i 's|^Icon=.*|Icon=/home/deck/Applications/Discord/discord.png|g' "${HOME}/.local/share/applications/${desktop_file}"
        fi

    fi

}

from_repo_install_yt_dlp() {

    func="from_repo_install_yt_dlp"

    [ $DEBUG -eq 1 ] && echo $func

    set +e

    if which yt-dlp; then

        FLAG_yt_dlp_installed=1

    fi

    set -e

    if [ $FLAG_yt_dlp_installed -eq 1 ]; then

        do_nothing=

    elif [ $OS = FEDORA_WSL ] || [ $OS = UBUNTU_WSL ]; then

        url="https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp"

        mkdir -p "${HOME}/.local/bin"

        curl -L "$url" -o "${HOME}/.local/bin/yt-dlp"

        chmod a+rx "${HOME}/.local/bin/yt-dlp"

        # To update run: `yt-dlp -U`

    fi

}

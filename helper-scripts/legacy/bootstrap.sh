#!/bin/bash

# Description: Helper snippets to get Fedora up and running.

# Exit on error
set -eE

trap 'exit_error $LINENO' ERR
trap 'exit_zero' EXIT

# Declare switches (to control program flow)
DEBUG=0

# Valid OS switches:

#   FEDORA
#   FEDORA_WSL
#   STEAMOS
#   UBUNTU_WSL

# OS=FEDORA_WSL # DEPRECATED

# Declare constants
readonly APPLICATIONS="${HOME}/Applications"
# readonly CACHE="/cache/jonathan"
readonly CACHE="/cache.jonathan"
readonly DOCUMENTS="${HOME}/Documents"
readonly GIT="${HOME}/git"
readonly LIB='./lib'
readonly SCRIPT_FOLDER="$(dirname "$0")"
readonly SYSTEM_BIN="/usr/local/bin"
readonly SYSTEM_UNITS="/etc/systemd/system"

readonly RESOURCES="${SCRIPT_FOLDER}/resources"

# WSL
readonly WIN_USER="Jonathan"
readonly WIN_HOME="/mnt/c/Users/${WIN_USER}"

# Libraries
readonly ENV="${LIB}/env.sh"
readonly ERROR="${LIB}/error.sh"
readonly TEST="${LIB}/test.sh"

# Source external libraries
. "$ENV"
. "$ERROR"
. "$TEST"

###########################
#                         #
#          SETUP          #
#                         #
###########################

load_env

do=1
if [ $OS = FEDORA ] && [ $do -eq 1 ]; then

    mkdir -p "${HOME}/git"

fi

do=0
if [ $OS = FEDORA_WSL ] && [ $do -eq 1 ]; then

    # NOTE: This setup assumes that the whole of user's home directory, as
    # well as rootfs, is stored on host boot drive (presumably an SSD), no
    # optimizations necessary for applications installed locally within $HOME

    # NOTE: deprecated
    # mkdir -p "${HOME}/Desktop/@applications"

    mkdir -p "$APPLICATIONS"
    mkdir -p "$GIT"

    # [ ! -d "$APPLICATIONS" ] && ln -s "${HOME}/Desktop/@applications" "$APPLICATIONS"

fi

do=0
if [ $OS = UBUNTU_WSL ] && [ $do -eq 1 ]; then

    # NOTE: This setup assumes that the whole of user's home directory, as
    # well as rootfs, is stored on host boot drive (presumably an SSD), no
    # optimizations necessary for applications installed locally within $HOME

    mkdir -p "${HOME}/Desktop/@applications"
    mkdir -p "$GIT"

    [ ! -d "$APPLICATIONS" ] && ln -s "${HOME}/Desktop/@applications" "$APPLICATIONS"

fi

# Initialize flags with default values
FLAG_steamos_btrfs_installed=0
FLAG_password_set=0
FLAG_restart_required=0
FLAG_did_tweak_cpu=0
FLAG_did_tweak_mglru=0
FLAG_did_tweak_watchdog=0
FLAG_did_tweak_memory=0
FLAG_did_tweak_io_scheduler=0
FLAG_did_tweak_dragon=0
FLAG_steamapps_subvol_exists=0
FLAG_git_configured=0
FLAG_shared_config_nix_exists=0
FLAG_package_management_helper_scripts_exists=0
FLAG_btrfs_snp_installed=0
FLAG_kvm_configured=0
FLAG_images_subvol_exists=0
FLAG_emudeck_installed=0
FLAG_home_btrfs_configured=0
FLAG_ssh_configured=0
FLAG_rpmfusion_configured=0
FLAG_wsl_configured=0
FLAG_lightdm_configured=0
FLAG_rsync_helper_scripts_installed=0
FLAG_discord_installed=0
FLAG_yt_dlp_installed=0

configure_rpmfusion() {

    func="configure_rpmfusion"
    
    [ $DEBUG -eq 1 ] && echo $func

    if [ $OS = FEDORA ] || [ $OS = FEDORA_WSL ]; then

        repo_list=$(sudo dnf repolist)

        if echo "$repo_list" | grep -q "rpmfusion"; then

            FLAG_rpmfusion_configured=1

        fi

    fi

    if [ $FLAG_rpmfusion_configured -eq 1 ]; then

        do_nothing=

    elif [ $OS = FEDORA ] || [ $OS = FEDORA_WSL ]; then

        # To enable access to both the free and the nonfree repository use the following command:

        sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

        # On Fedora, we default to use the openh264 library, so you need the repository to be explicitely enabled:

        sudo dnf config-manager --enable fedora-cisco-openh264

        # RPM Fusion repositories also provide Appstream metadata to enable users to install packages using Gnome Software/KDE Discover. Please note that these are a subset of all packages since the metadata are only generated for GUI packages. The following command will install the required group of packages:

        sudo dnf install -y @core
        # sudo dnf update  -y @core

        # Fedora ffmpeg-free works most of the time, but one will experience version missmatch from time to time. Switch to the rpmfusion provided ffmpeg build that is better supported:

        sudo dnf swap ffmpeg-free ffmpeg --allowerasing

        # The following command will install the complements multimedia packages needed by gstreamer enabled applications:

        sudo dnf install -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
        # sudo dnf update  -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

        # The following command will install the sound-and-video complement packages needed by some applications:

        sudo dnf install -y @sound-and-video
        # sudo dnf update  -y @sound-and-video

        # Using the rpmfusion-nonfree section:

        sudo dnf install -y intel-media-driver

        # You need to have the libdvdcss package, to install libdvdcss you need enable tainted repos:

        sudo dnf install -y rpmfusion-free-release-tainted
        sudo dnf install -y libdvdcss

        # Tainted nonfree is dedicated to non-FLOSS packages without a clear redistribution status by the copyright holder. But is allowed as part of hardware inter-operability between operating systems in some countries:

        sudo dnf install -y rpmfusion-nonfree-release-tainted
        sudo dnf --repo=rpmfusion-nonfree-tainted install -y "*-firmware"

        FLAG_restart_required=1

    fi

}

configure_ssh() {

    func="configure_ssh"
    
    [ $DEBUG -eq 1 ] && echo $func

    dir="${HOME}/.ssh"

    if [ -d "$dir" ]; then

        FLAG_ssh_configured=1

    fi

    if [ $FLAG_ssh_configured -eq 0 ]; then

        # (read: create location for @ssh filepack, can reverse-clone ssh keys
        # from your file server later)

        # mkdir -p "${HOME}/Desktop/@ssh"
        mkdir -p "${HOME}/.filepacks/@ssh"

        # ln -s "${HOME}/Desktop/@ssh"  "${HOME}/.ssh"
        ln -s "${HOME}/.filepacks/@ssh"  "${HOME}/.ssh"

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

create_images_subvol() {

    func="create_images_subvol"
    
    [ $DEBUG -eq 1 ] && echo $func

    images_subvol="${HOME}/@images"

    if [ -d "$images_subvol" ]; then

        FLAG_images_subvol_exists=1

    fi

    if [ $FLAG_images_subvol_exists -eq 1 ]; then

        do_nothing=

    elif [ $OS = STEAMOS ]; then

        libvirt_folder="/var/lib/libvirt"
        images_folder_name="images"
        images_subvol_name="@images"

        sudo btrfs subvolume create "${HOME}/${images_subvol_name}"

        #######################################
        #                                     #
        #          !!! IMPORTANT !!!          #
        #                                     #
        #######################################
        sudo chattr +C "${HOME}/${images_subvol_name}"

        # NOTE: Trailing slashes are significant!
        sudo rsync -av "${libvirt_folder}/${images_folder_name}/" "${HOME}/${images_subvol_name}/"

        sudo rm -rf "${libvirt_folder}/${images_folder_name}"

        sudo ln -s "${HOME}/${images_subvol_name}" "${libvirt_folder}/${images_folder_name}"

    fi

}

package-management-helper-scripts-install() {

    func="placeholder"
    
    [ $DEBUG -eq 1 ] && echo $func

    if [ $FLAG_package_management_helper_scripts_exists -eq 0 ]; then

        repo_name="package-management-helper-scripts"

        cd "$GIT" && git clone "https://www.github.com/celluloid-demon/${repo_name}"

    fi

}

package-management-helper-scripts-check() {

    func="placeholder"
    
    [ $DEBUG -eq 1 ] && echo $func

    repo_name="package-management-helper-scripts"

    if [ -d "${GIT}/${repo_name}" ]; then

        FLAG_package_management_helper_scripts_exists=1

    fi

}

install_shared_config_nix() {

    func="install_shared_config_nix"
    
    [ $DEBUG -eq 1 ] && echo $func

    dir="${APPLICATIONS}/shared-config-nix"

    if [ -d "$dir" ]; then

        FLAG_shared_config_nix_exists=1

    fi

    if [ $FLAG_shared_config_nix_exists -eq 0 ]; then

        url="https://www.github.com/celluloid-demon/shared-config-nix"

        cd "$APPLICATIONS" && git clone "$url"

        cd "${HOME}"
        ln -s "${APPLICATIONS}/shared-config-nix/home/bin" bin
        ln -s "${APPLICATIONS}/shared-config-nix/home/usr" usr
        ln -s "${APPLICATIONS}/shared-config-nix/dot-files/bash_aliases" .bash_aliases

# source .bash_aliases through .bashrc
cat << EOF | tee -a "${HOME}/.bashrc"

if [ -f "\${HOME}/.bash_aliases" ]; then

    . "\${HOME}/.bash_aliases"

fi

EOF

    fi

}

configure_git() {

    func="configure_git"
    
    [ $DEBUG -eq 1 ] && echo $func

    # (temporarily disable exit on error)
    set +e
    git_user_name="$(git config --global --get user.name)"
    set -e

    if [ ! -z "$git_user_name" ]; then

        FLAG_git_configured=1

    fi

    if [ $FLAG_git_configured -eq 0 ]; then

        echo

        # Prompt for user's name
        read -p "Enter your git name (this can just be your first name, lower-case): " name

        # Prompt for user's email
        read -p "Enter your GitHub email (recommend GitHub ***private*** email): " email

        # Set the username in Git configuration
        git config --global user.name "$name"

        # Set the commit email address in Git configuration
        git config --global user.email "$email"

    fi

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

set_password() {

    func="set_password"
    
    [ $DEBUG -eq 1 ] && echo $func

    echo $OS

    if [ $OS = FEDORA* ]; then

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

configure_home_btrfs() {

    func="configure_home_btrfs"
    
    [ $DEBUG -eq 1 ] && echo $func

    set +e

    home_mount="$(cat /proc/mounts | grep /home)"

    if echo "$home_mount" | grep -q btrfs; then

        FLAG_home_btrfs_configured=1

    fi

    set -e

    if [ $FLAG_home_btrfs_configured -eq 1 ]; then

        echo "/home btrfs detected..."

    elif [ $OS = FEDORA ]; then

        echo "/home btrfs NOT detected (out of scope of this bootstrap, come back when it's done)"
        exit 1

    elif [ $OS = STEAMOS ]; then

        echo "/home btrfs NOT detected, do you wish to install steamos-btrfs? (y/n): "
        read response

        if [ "$response" = "y" ]; then

            # (SEE WARNING)
            install-steamos-btrfs

        elif [ "$response" = "n" ]; then

            echo "WARNING: steamos-btrfs required for optimizations, terminating..."
            exit 1

        else

            echo "Invalid response, terminating..."
            exit 1

        fi

    fi

}

install-steamos-btrfs() {

    func="placeholder"
    
    [ $DEBUG -eq 1 ] && echo $func

    # WARNING: Recommended to do this FIRST so downstream package / flatpak installations are able to take advantage of zstd compression.

    t="$(mktemp -d)"

    curl -sSL https://gitlab.com/popsulfr/steamos-btrfs/-/archive/main/steamos-btrfs-main.tar.gz | tar -xzf - -C "$t" --strip-components=1

    "$t/install.sh"

    rm -rf "$t"

    # Let steamos-btrfs do its thing
    exit 0

}

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

from_apt_install_packages() {

    func="from_apt_install_packages"
    
    [ $DEBUG -eq 1 ] && echo $func

    PACKAGES="byobu flatpak gh git htop podman pv rsync tldr tree"
    PACKAGES_DEV="build-essential"
    PACKAGES_TRANSCODING="ffmpeg"
    PACKAGES_PROXMOX='byobu gh git nano pv rsync tldr tree'
    PACKAGES_DOCKER='apt-utils'

    if [ $OS = UBUNTU_WSL ]; then

        sudo apt update
        sudo apt upgrade -y
        sudo apt install -y $PACKAGES $PACKAGES_DEV $PACKAGES_TRANSCODING

    fi

    if [ $OS = PROXMOX ]; then

        sudo apt update
        sudo apt upgrade -y
        sudo apt install -y $PACKAGES_PROXMOX

    fi

}

from_dnf_install_packages() {

    func="from_dnf_install_packages"
    
    [ $DEBUG -eq 1 ] && echo $func

    PACKAGES_COMMON="byobu gh git krfb nano pv rsync tldr tree"
    PACKAGES_WSL_ONLY="lightdm"
    PACKAGES_DOCKER="byobu gh git nano pv rsync tldr tree"

    if [ $OS = FEDORA ]; then

        PACKAGES_VSCODE="code"

        # WARNING: Fedora rootfs partition only has ~20G allocated for it, you've got wiggle room but you should still be relying on flatpaks for most apps

        # VSCode
        set +e
        if ! which code >/dev/null 2>&1; then

            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

            echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

        fi
        set -e

        sudo dnf upgrade -y
        sudo dnf install -y $PACKAGES_COMMON $PACKAGES_VSCODE

        sudo dnf groupinstall -y "Development Tools" "Development Libraries"

    fi

    if [ $OS = FEDORA_DOCKER ]; then

        sudo dnf upgrade -y
        sudo dnf install -y $PACKAGES_DOCKER

    fi

    if [ $OS = FEDORA_WSL ]; then

        # reference: https://docs.fedoraproject.org/en-US/quick-docs/switching-desktop-environments/

        sudo dnf upgrade -y
        sudo dnf install -y $PACKAGES_COMMON $PACKAGES_WSL_ONLY

        sudo dnf groupinstall -y "Development Tools" "Development Libraries"

        # sudo dnf install -y @kde-desktop
        # sudo dnf install -y @kde-desktop-environment
        sudo dnf groupinstall -y "KDE Plasma Workspaces"

    fi

}

from_snap_install_packages() {

    func="from_snap_install_packages"
    
    [ $DEBUG -eq 1 ] && echo $func

    SNAPS="
    
    anki-woodrow
    bing-wall
    folio
    halftone
    mediainfo-gui
    mpv
    pdfarranger
    qbittorrent-arnatious
    rnote
    shortwave
    
    "

    SNAPS_TRANSCODING="

    ffmpeg
    filebot
    handbrake-jz
    makemkv
    mkvtoolnix-jz
    
    "

    if [ $OS = UBUNTU_WSL ]; then

        sudo snap refresh

        # (note: workaround for possible snap bug, throws error if multiple pre-installed snaps listed)
        set +e

        sudo snap install $SNAPS $SNAPS_TRANSCODING

        set -e

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

btrfs-snp-install-from-repo() {

    func="placeholder"
    
    [ $DEBUG -eq 1 ] && echo $func

    if [ $OS = FEDORA ] || [ $OS = STEAMOS ]; then

        set +e
        if ! which btrfs-snp >/dev/null 2>&1; then

            set -e

            url="https://www.github.com/celluloid-demon/btrfs-snp"
            repo_name="$(basename "$url" .git)"

            cd "$APPLICATIONS"

            git clone "$url"

            cd "$repo_name"

            # unlock system
            if [ $OS = STEAMOS ]; then sudo steamos-readonly disable; fi

            ./flash

            # lock system
            if [ $OS = STEAMOS ]; then sudo steamos-readonly enable; fi

            FLAG_restart_required=1

        fi
        set -e

    fi

}

btrfs-sync-install-from-repo() {

    func="placeholder"
    
    [ $DEBUG -eq 1 ] && echo $func

    if [ $OS = FEDORA ] || [ $OS = STEAMOS ]; then

        set +e
        if ! which btrfs-sync >/dev/null 2>&1; then

            set -e

            url="https://www.github.com/celluloid-demon/btrfs-sync"
            repo_name="$(basename "$url" .git)"

            cd "$APPLICATIONS"

            git clone "$url"

            cd "$repo_name"

            # unlock system
            if [ $OS = STEAMOS ]; then sudo steamos-readonly disable; fi

            ./flash

            # lock system
            if [ $OS = STEAMOS ]; then sudo steamos-readonly enable; fi

            FLAG_restart_required=1

        fi
        set -e

    fi

}

from_repo_install_rsync_helper_scripts() {

    func="from_repo_install_rsync_helper_scripts"
    
    [ $DEBUG -eq 1 ] && echo $func

    set +e

    if which rsync-wrapper >/dev/null 2>&1; then

        FLAG_rsync_helper_scripts_installed=1

    fi

    set -e

    if [ $FLAG_rsync_helper_scripts_installed -eq 1 ]; then

        do_nothing=

    else

        url="https://www.github.com/celluloid-demon/rsync-helper-scripts"
        repo_name="$(basename "$url" .git)"

        cd "$APPLICATIONS"

        git clone "$url"

        cd "$repo_name"

        # unlock system
        if [ $OS = STEAMOS ]; then sudo steamos-readonly disable; fi

        # todo
        # ./flash

        # lock system
        if [ $OS = STEAMOS ]; then sudo steamos-readonly enable; fi

        FLAG_restart_required=1

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

from-web-get-emudeck-installer() {

    func="placeholder"
    
    [ $DEBUG -eq 1 ] && echo $func

    # grabbing essentially another bootstrap file, we don't need to get too fancy

    url="https://www.emudeck.com/EmuDeck.desktop"

    cd "${HOME}/Desktop" && wget "$url"

}

create_steamapps_subvol() {

    func="create_steamapps_subvol"
    
    [ $DEBUG -eq 1 ] && echo $func

    steam_folder="/home/deck/.local/share/Steam"
    steamapps_subvol_name="@steamapps"

    if [ -d "${steam_folder}/${steamapps_subvol_name}" ]; then

        FLAG_steamapps_subvol_exists=1

    fi

    if [ $OS = STEAMOS ] && [ $FLAG_steamapps_subvol_exists -eq 0 ]; then

        steam_folder="/home/deck/.local/share/Steam"
        steamapps_folder_name="steamapps"
        steamapps_subvol_name="@steamapps"

        # make sure steam isn't running while we're doing this
        echo
        echo "  WARNING: Please take a moment to close Steam (press enter when ready to procede)"
        read response

        # (create steamapps folder if missing to satisfy logic because I'm lazy)
        if [ ! -d "${steam_folder}/${steamapps_folder_name}" ]; then mkdir -p "${steam_folder}/${steamapps_folder_name}"; fi

        sudo btrfs subvolume create "${steam_folder}/${steamapps_subvol_name}"

        # NOTE: Trailing slashes are significant!
        sudo rsync -av "${steam_folder}/${steamapps_folder_name}/" "${steam_folder}/${steamapps_subvol_name}/"

        sudo rm -rf "${steam_folder}/${steamapps_folder_name}"

        ln -s "${steam_folder}/${steamapps_subvol_name}" "${steam_folder}/${steamapps_folder_name}"

    fi

}

exit_zero() {

    func="exit_zero"
    
    [ $DEBUG -eq 1 ] && echo $func

    if [ $FLAG_restart_required -eq 1 ]; then

        echo
        echo "  ######################################################"
        echo "  #                                                    #"
        echo "  #     WARNING: System restart highly encouraged!     #"
        echo "  #                                                    #"
        echo "  ######################################################"
        echo

    fi

    echo
    echo "  ...completed successfully!"
    echo

}

configure_wsl() {

    func="configure_wsl"
    
    [ $DEBUG -eq 1 ] && echo $func

    config="${WIN_HOME}/.wslconfig"

    if [ -f "$config" ]; then

        FLAG_wsl_configured=1

    fi

    if [ $OS = *_WSL ] && [ $FLAG_wsl_configured -eq 0 ]; then

cat << EOF | tee "$config"
[wsl2]
vmIdleTimeout=-1
EOF

        # WARNING: SERVICE LOGIC DEPRECATED (can just run echo command for same effect)

        # make a dummy systemd service (to be "manually" started by task
        # scheduler on windows login), this combined with the prior timeout setting will theoretically start wsl in the background and
        # allow it to keep running for other systemd services, mainly
        # rsync backup scripts
        # executable="dummy"
        # service="dummy.service"

        # sudo cp "${RESOURCES}/${executable}" "${SYSTEM_BIN}/"
        # sudo cp "${RESOURCES}/${service}"    "${SYSTEM_UNITS}/"

        # systemd-analyze verify "${SYSTEM_UNITS}/${service}"

        # NOTE: If you'd like to start this service whenever you login to Windows, create a "Scheduled Task" in Windows which runs on Logon and points to wsl.exe with the arguments being -u root -e sh -c "systemctl status dummy || systemctl start dummy"

        FLAG_restart_required=1

    fi

}

main() {

    # ###########################
    # #                         #
    # #          BEGIN          #
    # #                         #
    # ###########################

    # set_password

    # configure_wsl

    # configure_home_btrfs

    # install_steamos_tweak_cpu
    # install_steamos_tweak_mglru
    # install_steamos_tweak_watchdog
    # install_steamos_tweak_memory
    # install_steamos_tweak_io_scheduler
    # install_steamos_tweak_dragon

    # create_steamapps_subvol

    # ######################################
    # #                                    #
    # #          STAGE 1 PACKAGES          #
    # #                                    #
    # ######################################

    # configure_rpmfusion

    from_apt_install_packages

    from_dnf_install_packages

    # from_pacman_install_packages

    # ##################################
    # #                                #
    # #          End STAGE 1           #
    # #                                #
    # ##################################

    # configure_git

    # ###############################################
    # #                                             #
    # #          STAGE 2 PACKAGES                   #
    # #                                             #
    # #            DEPENDS ON: git, flatpak         #
    # #                                             #
    # ###############################################

    # from_flathub_install_packages

    # from_snap_install_packages

    # from_repo_install_rsync_helper_scripts

    # from_repo_install_yt_dlp

    # from_web_install_discord

    # install_shared_config_nix

    # configure_ssh

    # create_images_subvol

}

main

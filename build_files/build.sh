#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux
dnf5 install -y thunderbird

# AD domain membership (realmd/sssd/adcli/krb5) and 802.1x cert enrollment
# from AD CS via certmonger's SCEP client (targets the NDES role for EAP-TLS certs)
dnf5 install -y \
    realmd \
    sssd \
    sssd-ad \
    sssd-tools \
    adcli \
    samba-common-tools \
    krb5-workstation \
    oddjob \
    oddjob-mkhomedir \
    authselect \
    policycoreutils-python-utils \
    certmonger \
    nss-tools \
    wpa_supplicant

# certmonger needs to run persistently to track and renew enrolled certs;
# sssd/realmd are left disabled here since `realm join` enables them at
# runtime once the machine can actually reach a domain controller.
systemctl enable certmonger.service

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

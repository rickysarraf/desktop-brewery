# Base Image: Fedora 41
FROM fedora:41

# 1. DNF configuration
RUN echo "exclude=kernel* grub2* shim* memtest86* grubby*" >> /etc/dnf/dnf.conf

# 2. Add COSMIC COPR and Install
RUN dnf install -y 'dnf-command(copr)' && \
    dnf copr enable -y ryanabx/cosmic-epoch fedora-41-x86_64 && \
    dnf install -y \
    ca-certificates curl dbus-x11 mesa-dri-drivers pipewire procps-ng sudo \
    cosmic-desktop cosmic-terminal cosmic-files cosmic-edit xorg-x11-server-Xwayland && \
    dnf clean all

# 3. User Setup
ARG USER_NAME=rrs
ARG USER_UID=1000
RUN useradd -m -u $USER_UID -s /bin/bash $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME

USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/cosmic-session"]

# Base Image: Fedora 41 (Stable for COSMIC)
FROM fedora:41

# 1. Image Optimization: Exclude kernel and boot bits in DNF
RUN echo "exclude=kernel* grub2* shim* memtest86* grubby*" >> /etc/dnf/dnf.conf

# 2. Add COSMIC COPR and Install
RUN dnf install -y 'dnf-command(copr)' && \
    dnf copr enable -y ryanabx/cosmic-epoch && \
    dnf install -y \
    ca-certificates curl dbus-x11 mesa-dri-drivers pipewire procps-ng sudo \
    cosmic-desktop cosmic-terminal cosmic-files cosmic-edit xorg-x11-server-Xwayland

# 3. User Setup
ARG USER_NAME=rrs
ARG USER_UID=1000
RUN useradd -m -u $USER_UID -s /bin/bash $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME

# 4. Validation
RUN which cosmic-session

USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/cosmic-session"]

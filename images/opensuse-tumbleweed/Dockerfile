# Base Image: openSUSE Tumbleweed
FROM opensuse/tumbleweed

# 1. Update and install KDE Plasma
RUN zypper --non-interactive update && \
    zypper --non-interactive install --no-recommends \
    ca-certificates curl dbus-1-x11 Mesa-dri-drivers pipewire procps sudo systemd-container \
    patterns-kde-plasma_core konsole dolphin

# 2. User Setup
ARG USER_NAME=rrs
ARG USER_UID=1000
RUN useradd -m -u $USER_UID -s /bin/bash $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME

# 3. Validation
RUN rpm -q patterns-kde-plasma_core

USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/startplasma-wayland"]

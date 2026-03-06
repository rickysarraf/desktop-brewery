# Base Image: openSUSE Tumbleweed
FROM opensuse/tumbleweed

RUN zypper --non-interactive install --no-recommends \
    ca-certificates curl dbus-1-x11 Mesa-dri-drivers pipewire procps sudo systemd-container \
    patterns-kde-plasma_core konsole dolphin && \
    zypper clean --all

ARG USER_NAME=rrs
ARG USER_UID=1000
RUN useradd -m -u $USER_UID -s /bin/bash $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME

USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/startplasma-wayland"]

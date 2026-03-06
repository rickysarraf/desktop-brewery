# openSUSE Tumbleweed KDE
FROM opensuse/tumbleweed
RUN zypper --non-interactive install --no-recommends \
    ca-certificates curl dbus-1-x11 Mesa-dri-drivers pipewire procps sudo \
    patterns-kde-kde_plasma konsole dolphin && \
    zypper clean --all
ARG USER_NAME=rrs
RUN useradd -m -u 1000 -s /bin/bash $USER_NAME && echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME
USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/startplasma-wayland"]

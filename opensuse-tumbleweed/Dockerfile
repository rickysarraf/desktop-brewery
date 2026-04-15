# openSUSE Tumbleweed KDE
FROM opensuse/tumbleweed
RUN zypper --non-interactive install --no-recommends \
    ca-certificates curl dbus-1-daemon Mesa-dri pipewire procps sudo \
    patterns-kde-kde_plasma konsole dolphin && \
    zypper clean --all
ARG USER_NAME=rrs
RUN if id -u 1000 >/dev/null 2>&1; then \
        usermod -l $USER_NAME $(id -nu 1000); \
    else \
        useradd -m -u 1000 -s /bin/bash $USER_NAME; \
    fi && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME
USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/startplasma-wayland"]

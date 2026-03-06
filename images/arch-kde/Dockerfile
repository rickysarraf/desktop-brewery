# Base Image: Arch Linux
FROM archlinux:latest

RUN echo -e "[options]\nIgnorePkg = linux linux-firmware" >> /etc/pacman.conf

RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm --needed \
    ca-certificates curl dbus mesa pipewire procps-ng sudo systemd-container \
    plasma-desktop konsole dolphin && \
    pacman -Scc --noconfirm

ARG USER_NAME=rrs
ARG USER_UID=1000
RUN useradd -m -u $USER_UID -s /bin/bash $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME

USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/startplasma-wayland"]

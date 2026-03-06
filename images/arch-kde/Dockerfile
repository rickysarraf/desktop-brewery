# Base Image: Arch Linux
FROM archlinux:latest

# 1. Image Optimization: Ignore kernel and firmware in Pacman
RUN echo -e "[options]\nIgnorePkg = linux linux-firmware" >> /etc/pacman.conf

# 2. Update and install KDE Plasma
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm --needed \
    ca-certificates curl dbus mesa pipewire procps-ng sudo systemd-container \
    plasma-desktop konsole dolphin

# 3. User Setup
ARG USER_NAME=rrs
ARG USER_UID=1000
RUN useradd -m -u $USER_UID -s /bin/bash $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME

# 4. Validation
RUN pacman -Q plasma-desktop

USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/startplasma-wayland"]

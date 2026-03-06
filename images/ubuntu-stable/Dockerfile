# Base Image: Ubuntu Stable
FROM ubuntu:noble

RUN mkdir -p /etc/dpkg/dpkg.cfg.d/ && \
    echo 'path-exclude /boot/*' > /etc/dpkg/dpkg.cfg.d/exclude-boot && \
    echo 'path-exclude /lib/modules/*' >> /etc/dpkg/dpkg.cfg.d/exclude-boot

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates curl dbus-x11 gnupg locales mesa-dri-drivers pipewire-audio procps sudo systemd-container \
    ubuntu-desktop-minimal gnome-terminal nautilus && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ARG USER_NAME=rrs
ARG USER_UID=1000
RUN useradd -m -u $USER_UID -s /bin/bash $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME

USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/gnome-session"]

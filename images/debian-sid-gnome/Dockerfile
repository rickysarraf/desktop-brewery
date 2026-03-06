# Base Image: Debian Unstable
FROM debian:sid

RUN mkdir -p /etc/dpkg/dpkg.cfg.d/ && \
    echo 'path-exclude /boot/*' > /etc/dpkg/dpkg.cfg.d/exclude-boot && \
    echo 'path-exclude /lib/modules/*' >> /etc/dpkg/dpkg.cfg.d/exclude-boot

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates curl dbus-x11 gnupg locales mesa-dri-drivers pipewire-audio procps sudo systemd-container \
    gnome-session gnome-terminal nautilus gnome-control-center gnome-settings-daemon gsettings-desktop-schemas && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ARG USER_NAME=rrs
ARG USER_UID=1000
RUN useradd -m -u $USER_UID -s /bin/bash $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME

USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/gnome-session"]

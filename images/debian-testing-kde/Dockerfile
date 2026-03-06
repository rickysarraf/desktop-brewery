# Base Image: Debian Testing
FROM debian:testing-slim

# 1. Image Optimization: Exclude boot and kernel modules to keep the image lean
RUN mkdir -p /etc/dpkg/dpkg.cfg.d/ && \
    echo 'path-exclude /boot/*' > /etc/dpkg/dpkg.cfg.d/exclude-boot && \
    echo 'path-exclude /lib/modules/*' >> /etc/dpkg/dpkg.cfg.d/exclude-boot

# 2. Prevent recommended packages and update system
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    ca-certificates \
    curl \
    dbus-x11 \
    gnupg \
    locales \
    mesa-dri-drivers \
    pipewire-audio \
    procps \
    sudo \
    systemd-container \
    # Primary Desktop Environment
    kde-plasma-desktop \
    # Essential Productivity Tools
    firefox-esr \
    konsole \
    dolphin

# 3. Setup Locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# 4. User Setup (Matching Host UID 1000)
ARG USER_NAME=rrs
ARG USER_UID=1000
RUN useradd -m -u $USER_UID -s /bin/bash $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME && \
    chmod 0440 /etc/sudoers.d/$USER_NAME

# 5. Validation Test: Ensure plasma-desktop is installed
RUN dpkg -l | grep plasma-desktop

USER $USER_NAME
WORKDIR /home/$USER_NAME

# The entrypoint will be handled by the Base OS session wrapper
CMD ["/usr/bin/startplasma-wayland"]

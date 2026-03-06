# Base Image: Debian Testing
FROM debian:testing

# 1. Image Optimization
RUN mkdir -p /etc/dpkg/dpkg.cfg.d/ && \
    echo 'path-exclude /boot/*' > /etc/dpkg/dpkg.cfg.d/exclude-boot && \
    echo 'path-exclude /lib/modules/*' >> /etc/dpkg/dpkg.cfg.d/exclude-boot

# 2. Install Desktop Components
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
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
    kde-plasma-desktop \
    firefox-esr \
    konsole \
    dolphin && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Setup Locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# 4. User Setup
ARG USER_NAME=rrs
ARG USER_UID=1000
RUN useradd -m -u $USER_UID -s /bin/bash $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME

USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/startplasma-wayland"]

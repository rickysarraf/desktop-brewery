# Base Image: Debian Unstable (Sid)
FROM debian:sid-slim

# 1. Image Optimization: Exclude boot and kernel modules
RUN mkdir -p /etc/dpkg/dpkg.cfg.d/ && \
    echo 'path-exclude /boot/*' > /etc/dpkg/dpkg.cfg.d/exclude-boot && \
    echo 'path-exclude /lib/modules/*' >> /etc/dpkg/dpkg.cfg.d/exclude-boot

# 2. Update and install GNOME Desktop
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    ca-certificates curl dbus-x11 gnupg locales mesa-dri-drivers pipewire-audio procps sudo systemd-container \
    gnome-session gnome-terminal nautilus \
    # Minimum apps for a usable GNOME environment
    gnome-control-center gnome-settings-daemon gsettings-desktop-schemas

# 3. Setup Locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# 4. User Setup
ARG USER_NAME=rrs
ARG USER_UID=1000
RUN useradd -m -u $USER_UID -s /bin/bash $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME

# 5. Validation
RUN dpkg -l | grep gnome-session

USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/gnome-session"]

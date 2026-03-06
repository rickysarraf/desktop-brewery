# Base Image: Pop!_OS
FROM ubuntu:noble

# 1. Image Optimization
RUN mkdir -p /etc/dpkg/dpkg.cfg.d/ && \
    echo 'path-exclude /boot/*' > /etc/dpkg/dpkg.cfg.d/exclude-boot && \
    echo 'path-exclude /lib/modules/*' >> /etc/dpkg/dpkg.cfg.d/exclude-boot

# 2. Add Pop!_OS Repos and Install COSMIC
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common curl gnupg && \
    add-apt-repository -y ppa:system76/pop && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates curl dbus-x11 locales mesa-dri-drivers pipewire-audio procps sudo systemd-container \
    cosmic-session cosmic-terminal cosmic-files cosmic-edit

# 3. Setup Locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# 4. User Setup
ARG USER_NAME=rrs
ARG USER_UID=1000
RUN useradd -m -u $USER_UID -s /bin/bash $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME

# 5. Validation
RUN which cosmic-session

USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/cosmic-session"]

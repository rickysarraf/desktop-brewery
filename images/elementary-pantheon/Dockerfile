# Elementary OS Pantheon
FROM ubuntu:noble
RUN mkdir -p /etc/dpkg/dpkg.cfg.d/ && echo 'path-exclude /boot/*' > /etc/dpkg/dpkg.cfg.d/exclude-boot
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl gnupg && \
    mkdir -p /etc/apt/keyrings && \
    echo "deb http://ppa.launchpad.net/elementary-os/stable/ubuntu noble main" > /etc/apt/sources.list.d/elementary.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A74F0309 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates curl dbus-x11 locales libgl1-mesa-dri pipewire-audio procps sudo \
    elementary-desktop io.elementary.terminal io.elementary.files && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ARG USER_NAME=rrs
RUN if id -u 1000 >/dev/null 2>&1; then \
        usermod -l $USER_NAME $(id -nu 1000); \
    else \
        useradd -m -u 1000 -s /bin/bash $USER_NAME; \
    fi && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME
USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/pantheon-session"]

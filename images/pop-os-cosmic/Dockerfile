# Pop!_OS COSMIC
FROM ubuntu:noble
RUN mkdir -p /etc/dpkg/dpkg.cfg.d/ && echo 'path-exclude /boot/*' > /etc/dpkg/dpkg.cfg.d/exclude-boot
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://packagecloud.io/system76/pop/gpgkey | gpg --dearmor -o /etc/apt/keyrings/system76-pop.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/system76-pop.gpg] http://ppa.launchpad.net/system76/pop/ubuntu noble main" > /etc/apt/sources.list.d/system76-pop.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates curl dbus-x11 locales libgl1-mesa-dri pipewire-audio procps sudo \
    cosmic-session cosmic-term cosmic-files cosmic-edit && \
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
CMD ["/usr/bin/cosmic-session"]

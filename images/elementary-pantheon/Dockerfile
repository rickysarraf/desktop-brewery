# Elementary OS Pantheon
FROM ubuntu:noble
RUN mkdir -p /etc/dpkg/dpkg.cfg.d/ && echo 'path-exclude /boot/*' > /etc/dpkg/dpkg.cfg.d/exclude-boot
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common curl gnupg && \
    add-apt-repository -y ppa:elementary-os/stable && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates curl dbus-x11 locales libgl1-mesa-dri pipewire-audio procps sudo \
    elementary-desktop io.elementary.terminal io.elementary.files && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ARG USER_NAME=rrs
RUN useradd -m -u 1000 -s /bin/bash $USER_NAME && echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME
USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/pantheon-session"]

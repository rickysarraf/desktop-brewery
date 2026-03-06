# Ubuntu Stable GNOME
FROM ubuntu:noble
RUN mkdir -p /etc/dpkg/dpkg.cfg.d/ && echo 'path-exclude /boot/*' > /etc/dpkg/dpkg.cfg.d/exclude-boot
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl dbus-x11 gnupg locales libgl1-mesa-dri pipewire-audio procps sudo \
    ubuntu-desktop-minimal gnome-terminal nautilus && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ARG USER_NAME=rrs
# Ubuntu Noble images often have a 'ubuntu' user at 1000. We'll reuse or replace.
RUN if id -u 1000 >/dev/null 2>&1; then \
        existing_user=$(id -nu 1000); \
        if [ "$existing_user" != "$USER_NAME" ]; then \
            usermod -l $USER_NAME $existing_user; \
            groupmod -n $USER_NAME $(id -ng $USER_NAME); \
            usermod -d /home/$USER_NAME -m $USER_NAME; \
        fi; \
    else \
        useradd -m -u 1000 -s /bin/bash $USER_NAME; \
    fi && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME
USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/gnome-session"]

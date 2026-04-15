# Fedora COSMIC
FROM fedora:41
RUN echo "exclude=kernel* grub2* shim* memtest86* grubby*" >> /etc/dnf/dnf.conf
RUN dnf install -y 'dnf-command(copr)' && \
    dnf copr enable -y ryanabx/cosmic-epoch fedora-41-x86_64 && \
    dnf install -y \
    ca-certificates curl dbus-x11 mesa-dri-drivers pipewire procps-ng sudo \
    cosmic-desktop cosmic-term cosmic-files cosmic-edit xorg-x11-server-Xwayland && \
    dnf clean all
ARG USER_NAME=rrs
RUN useradd -m -u 1000 -s /bin/bash $USER_NAME && echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME
USER $USER_NAME
WORKDIR /home/$USER_NAME
CMD ["/usr/bin/cosmic-session"]

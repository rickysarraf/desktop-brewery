#!/bin/bash
# Exclusive Desktop Session Runner (Full-screen Takeover)
# This script launches a container with direct access to hardware.
# WARNING: This will attempt to take over the screen.

IMAGE=$1
if [ -z "$IMAGE" ]; then
    echo "Usage: $0 <image_name>"
    echo "Example: $0 desktop-fedora-cosmic"
    exit 1
fi

CONTAINER_NAME="brewery-exclusive"
USER_UID=$(id -u)
USER_NAME="rrs"

echo "🛑 CAUTION: This will attempt a full-screen hardware takeover."
echo "If it fails, you may need to switch TTYs (Ctrl+Alt+F3) to recover."
read -p "Proceed? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# Cleanup old container
docker rm -f $CONTAINER_NAME 2>/dev/null

# Start the container
# We do NOT pass WAYLAND_DISPLAY here. We want the compositor inside
# to find the GPU and become the DRM Master.
docker run -it --rm \
    --name $CONTAINER_NAME \
    --privileged \
    --network host \
    --ipc host \
    --device /dev/dri:/dev/dri \
    --device /dev/input:/dev/input \
    --volume /run/udev:/run/udev:ro \
    --volume /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
    --volume /home/rrs:/home/rrs \
    $IMAGE

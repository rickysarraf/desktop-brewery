#!/bin/bash
# Desktop Brewery - Universal Nested Runner
# Usage: ./brewery-run.sh <image_name> [session_binary]
# Example: ./brewery-run.sh desktop-fedora-cosmic cosmic-session

IMAGE_NAME=$1
SESSION_CMD=$2
TARGET_WAYLAND_DISPLAY=${3:-$WAYLAND_DISPLAY}

if [ -z "$IMAGE_NAME" ]; then
    echo "Usage: $0 <image_name> [session_binary] [target_wayland_display]"
    echo "Available images:"
    docker images "ghcr.io/rickysarraf/*" --format "{{.Repository}}"
    exit 1
fi

# Configuration
CONTAINER_NAME="brewery-test-$(echo $IMAGE_NAME | tr '/:' '-')"
USER_UID=$(id -u)
USER_NAME="rrs"
HOST_XDG_RUNTIME_DIR="/run/user/$USER_UID"

# Ensure target Wayland display exists
if [ ! -S "$HOST_XDG_RUNTIME_DIR/$TARGET_WAYLAND_DISPLAY" ]; then
    echo "Error: Wayland socket $HOST_XDG_RUNTIME_DIR/$TARGET_WAYLAND_DISPLAY not found."
    exit 1
fi

echo "🚀 Preparing to launch $IMAGE_NAME nested on $TARGET_WAYLAND_DISPLAY..."

# Cleanup old container if it exists
docker rm -f $CONTAINER_NAME 2>/dev/null

# Start the container
docker run -d --name $CONTAINER_NAME \
    --privileged \
    --network host \
    --device /dev/dri:/dev/dri \
    --volume /dev/input:/dev/input \
    --volume /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
    --volume $HOST_XDG_RUNTIME_DIR:$HOST_XDG_RUNTIME_DIR \
    --volume /home/rrs:/home/rrs \
    $IMAGE_NAME sleep infinity

echo "🖥️  Launching session..."

# If SESSION_CMD is not provided, try to extract it from the image CMD
if [ -z "$SESSION_CMD" ]; then
    SESSION_CMD=$(docker inspect --format='{{join .Config.Cmd " "}}' $IMAGE_NAME)
fi

docker exec -u $USER_NAME -it \
    --env WAYLAND_DISPLAY=$TARGET_WAYLAND_DISPLAY \
    --env XDG_RUNTIME_DIR=/tmp/brewery-runtime \
    $CONTAINER_NAME /bin/bash -c "
        # Setup private runtime dir
        mkdir -p \$XDG_RUNTIME_DIR
        chmod 700 \$XDG_RUNTIME_DIR
        
        # Link host Wayland socket
        ln -sf $HOST_XDG_RUNTIME_DIR/$TARGET_WAYLAND_DISPLAY \$XDG_RUNTIME_DIR/$TARGET_WAYLAND_DISPLAY
        
        # Launch session
        echo \"Starting: $SESSION_CMD\"
        dbus-run-session $SESSION_CMD
    "

# Cleanup after session ends
docker rm -f $CONTAINER_NAME

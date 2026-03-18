#!/bin/bash
# Universal Nested Desktop Runner (Validation)
# Usage: ./brewery-nested.sh <image_name>

IMAGE=$1
if [ -z "$IMAGE" ]; then
    echo "Usage: $0 <image_name>"
    exit 1
fi

# 1. Start Weston in the background
WESTON_SOCKET="wayland-brewery"
echo "🌀 Starting Weston sandbox..."
# Remove --title as it is an unhandled option in some versions/backends
weston --socket=$WESTON_SOCKET --width=1280 --height=720 &
WESTON_PID=$!

# Wait for the socket to appear
MAX_RETRIES=10
RETRIES=0
while [ ! -S "$XDG_RUNTIME_DIR/$WESTON_SOCKET" ] && [ $RETRIES -lt $MAX_RETRIES ]; do
    echo "Waiting for $WESTON_SOCKET... ($RETRIES)"
    sleep 1
    ((RETRIES++))
done

if [ ! -S "$XDG_RUNTIME_DIR/$WESTON_SOCKET" ]; then
    echo "Error: Weston failed to create socket $WESTON_SOCKET"
    kill $WESTON_PID 2>/dev/null
    exit 1
fi

# 2. Run the container nested inside that Weston window
echo "🚀 Launching $IMAGE..."
./brewery-run.sh "$IMAGE" "" "$WESTON_SOCKET"

# 3. Cleanup Weston when the container exits
kill $WESTON_PID 2>/dev/null

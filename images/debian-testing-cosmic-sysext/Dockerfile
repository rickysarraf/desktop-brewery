# Stage 1: Builder
FROM debian:testing AS builder

# Arguments for GitHub Actions Cache
ARG ACTIONS_CACHE_URL
ARG ACTIONS_RUNTIME_TOKEN

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# 1. Add build dependencies
RUN apt-get update && apt-get install -y \
    build-essential git just cargo rustc pkg-config \
    libpipewire-0.3-dev libspa-0.2-dev libwayland-dev libxkbcommon-dev \
    libinput-dev libseat-dev libudev-dev libgbm-dev libdrm-dev \
    libdbus-1-dev libpam0g-dev libfontconfig-dev libfreetype-dev \
    libpolkit-gobject-1-dev libgudev-1.0-dev libglib2.0-dev \
    libjson-glib-dev libpulse-dev libasound2-dev libssl-dev \
    libflatpak-dev libostree-dev libarchive-dev libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev clang llvm-dev cmake \
    libpixman-1-dev libwayland-bin libdisplay-info-dev libxcb-xinput-dev \
    wayland-protocols extra-cmake-modules scdoc sed make libclang-dev \
    sccache gtk-update-icon-cache hicolor-icon-theme bsdextrautils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# 2. Global Rust Optimization Overrides for CI (Memory Safety)
ENV CARGO_PROFILE_RELEASE_LTO=thin
ENV CARGO_PROFILE_RELEASE_CODEGEN_UNITS=16
ENV CARGO_PROFILE_RELEASE_PANIC=abort
ENV CARGO_INCREMENTAL=0

# 3. FORCE sccache via compiler hijacking (The "Nuclear Option")
# This ensures sccache is used regardless of environment scrubbing by build tools.
RUN mv /usr/bin/rustc /usr/bin/rustc.real && \
    echo '#!/bin/bash' > /usr/bin/rustc && \
    echo 'exec /usr/bin/sccache /usr/bin/rustc.real "$@"' >> /usr/bin/rustc && \
    chmod +x /usr/bin/rustc

# 4. Configure sccache to use GitHub Actions Cache Backend
ENV SCCACHE_GHA_ENABLED=true
ENV ACTIONS_CACHE_URL=${ACTIONS_CACHE_URL}
ENV ACTIONS_RUNTIME_TOKEN=${ACTIONS_RUNTIME_TOKEN}
ENV LIBCLANG_PATH=/usr/lib/llvm-21/lib

# Mark the directory as safe for git
RUN git config --global --add safe.directory /build && \
    git clone --recursive --branch epoch-1.0.8 https://github.com/pop-os/cosmic-epoch.git .

# 5. TARGETED VALIDATION: Build only cosmic-randr correctly
RUN mkdir -p /export/usr && \
    sh -c "cd cosmic-randr && just build-release && just rootdir=/export prefix=/usr install"

# 6. Show sccache statistics
RUN sccache --show-stats

# 7. SANitization: Remove fundamental system binaries
RUN rm -f /export/usr/bin/env /export/usr/bin/bash /export/usr/bin/sh /export/usr/bin/dash

# Prepare metadata
RUN echo 'ID=debian' > /export/extension-release.cosmic && \
    echo 'SYSEXT_LEVEL=1' >> /export/extension-release.cosmic

# Stage 2: Packaging
FROM busybox
COPY --from=builder /export/extension-release.cosmic /usr/lib/extension-release.d/extension-release.cosmic
COPY --from=builder /export/usr /usr

LABEL org.opencontainers.image.source="https://github.com/rickysarraf/desktop-brewery"
LABEL org.opencontainers.image.description="Debian COSMIC System Extension (Diligence Build)"
LABEL org.opencontainers.image.licenses="GPL-3.0"

CMD ["sh"]

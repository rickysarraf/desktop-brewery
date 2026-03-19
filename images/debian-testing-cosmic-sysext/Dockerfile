# Stage 1: Builder
FROM debian:testing AS builder

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# 1. Add sccache, late-stage icon dependencies, and bsdextrautils (for 'rev')
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

# Set working directory
WORKDIR /build

# 2. Global Rust Optimization Overrides for CI (Memory Safety)
# Using ThinLTO instead of FatLTO to stay within GitHub's 7GB RAM limit
ENV CARGO_PROFILE_RELEASE_LTO=thin
ENV CARGO_PROFILE_RELEASE_CODEGEN_UNITS=16
ENV CARGO_PROFILE_RELEASE_PANIC=abort

# 3. Configure sccache for Rust
ENV RUSTC_WRAPPER=sccache
ENV SCCACHE_DIR=/root/.cache/sccache
ENV LIBCLANG_PATH=/usr/lib/llvm-21/lib

# Clone the COSMIC monorepo (Epoch 1.0.8)
# Note: Shallow clones (--depth 1) can cause panics in 'vergen' build scripts (e.g., cosmic-player)
RUN git config --global --add safe.directory /build && \
    git clone --recursive --branch epoch-1.0.8 https://github.com/pop-os/cosmic-epoch.git .

# 4. Build and install with persistent cache mounts
# Create /export first
RUN mkdir -p /export

# Run build/install with mounts (mounts MUST be the first thing after RUN)
RUN --mount=type=cache,target=/root/.cargo/registry \
    --mount=type=cache,target=/root/.cargo/git \
    --mount=type=cache,target=/root/.cache/sccache \
    just install /export /usr

# 5. Show sccache statistics for transparency
RUN --mount=type=cache,target=/root/.cache/sccache \
    sccache --show-stats

# Prepare the extension-release metadata
RUN cp /etc/os-release /export/extension-release.cosmic && \
    sed -i 's/^ID=/SYSEXT_LEVEL=1\nID=/' /export/extension-release.cosmic

# Stage 2: Packaging (The Sysext Image)
FROM scratch
COPY --from=builder /export/extension-release.cosmic /usr/lib/extension-release.d/extension-release.cosmic
COPY --from=builder /export/usr /usr

# Labels for GHCR
LABEL org.opencontainers.image.source="https://github.com/riteshsarraf/desktop-brewery"
LABEL org.opencontainers.image.description="Debian COSMIC System Extension (Optimized Sysext)"
LABEL org.opencontainers.image.licenses="GPL-3.0"

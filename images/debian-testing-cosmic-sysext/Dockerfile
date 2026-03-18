# Stage 1: Builder
FROM debian:testing AS builder

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Update and install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    just \
    cargo \
    rustc \
    pkg-config \
    libpipewire-0.3-dev \
    libspa-0.2-dev \
    libwayland-dev \
    libxkbcommon-dev \
    libinput-dev \
    libseat-dev \
    libudev-dev \
    libgbm-dev \
    libdrm-dev \
    libdbus-1-dev \
    libpam0g-dev \
    libfontconfig-dev \
    libfreetype-dev \
    libpolkit-gobject-1-dev \
    libgudev-1.0-dev \
    libglib2.0-dev \
    libjson-glib-dev \
    libpulse-dev \
    libasound2-dev \
    libssl-dev \
    libflatpak-dev \
    libostree-dev \
    libarchive-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    clang \
    llvm-dev \
    cmake \
    libpixman-1-dev \
    libwayland-bin \
    wayland-protocols \
    extra-cmake-modules \
    scdoc \
    sed \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /build

# Clone the COSMIC monorepo (Epoch 1.0.8)
# Using a more robust shallow clone for submodules to speed up CI
RUN git clone --recursive --depth 1 --branch epoch-1.0.8 https://github.com/pop-os/cosmic-epoch.git .

# Build all components using just
# This mimics your local 'just build' approach
RUN just build-release --prefix /usr --destdir /export

# Prepare the extension-release metadata in the builder stage
# (This avoids needing 'sed' in the final scratch stage)
RUN cp /etc/os-release /export/extension-release.cosmic && \
    sed -i 's/^ID=/SYSEXT_LEVEL=1\nID=/' /export/extension-release.cosmic

# Stage 2: Packaging (The Sysext Image)
FROM scratch

# Copy the metadata to the correct sysext path
COPY --from=builder /export/extension-release.cosmic /usr/lib/extension-release.d/extension-release.cosmic

# Copy the built hierarchy
COPY --from=builder /export/usr /usr

# Labels for GHCR
LABEL org.opencontainers.image.source="https://github.com/riteshsarraf/desktop-brewery"
LABEL org.opencontainers.image.description="Debian COSMIC System Extension (Sysext)"
LABEL org.opencontainers.image.licenses="GPL-3.0"

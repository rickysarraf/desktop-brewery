# Project: Desktop Brewery

## 1. Objective
To build a "Desktop as Code" environment. A lean, indestructible Base OS handles hardware and orchestration, while all User Interfaces (DEs) are interchangeable OCI container payloads brewed in GitHub, validated via CI, and delivered via GHCR.

## 2. Core Architecture: The Atomic Switchboard

### Layer 0: The Base OS (Hypervisor)
*   **Target:** Minimal Debian Stable or Testing.
*   **Filesystem:** Btrfs (Mandatory for subvolume snapshots/golden images).
*   **Role:** DRM Master, networking, firewall, and container orchestration.
*   **Key Services:** `systemd-nspawn`, `docker` (for work), `greetd`, `pipewire` (host-level).

### Layer 1: The Delivery Pipeline (Brewery)
*   **Source:** GitHub Actions repo `desktop-brewery`.
*   **Logic:**
    *   Exclude: `linux-image-*`, `grub-*`, `initramfs-tools`, firmware.
    *   Include: Full DE stacks (KDE, COSMIC, etc.), `dbus-x11`, `mesa-dri-drivers`.
    *   CI Test: Verify compositor binary execution before push.
*   **Registry:** GHCR (`ghcr.io/rrs/*`).

### Layer 2: The Payload Desktops
*   **Daily Driver:** Debian Testing (KDE Plasma).
*   **Exploration:** Fedora COSMIC (F41+), Debian Unstable, Arch Linux, NixOS.
*   **Integration:** Inter-connected via `systemd-nspawn` booting into a full init (`-b`).

### Layer 3: The Handover & Integration
*   **GPU/Input:** Passthrough of `/dev/dri` and `/dev/input`.
*   **DBus Bridging:** Bind-mount `/run/dbus/system_bus_socket` to allow containers to control host NetworkManager/Power.
*   **Audio:** Shared Pipewire socket.
*   **Persistence:** Host `/home/rrs` is bind-mounted to all containers. Desktop environments are ephemeral; your work and muscle memory are persistent.

---

## 3. Phased Plan of Action

### Phase 1: CI/CD Brewery (Current Priority)
*   Draft optimized Dockerfiles for each target distro.
*   Configure GitHub Actions to build and push to GHCR.
*   **Goal:** A library of ready-to-pull OS/Desktop images.

### Phase 2: Base OS Proof of Concept
*   Setup a virtualized/spare machine with Debian + Btrfs + `greetd`.
*   Engineer the `nspawn` session wrapper to take over the screen (DRM Master).
*   **Goal:** Validated hardware handover.

### Phase 3: Hardware Refinement
*   Tune UID/GID mapping for seamless `/dev/dri` and `/dev/input` access.
*   Script the "Promote to Golden" logic: Snapshot a Btrfs subvolume before updating from GHCR.
*   **Goal:** Production-ready reliability.

### Phase 4: Migration
*   Pave the primary workhorse.
*   Deploy the Atomic Switchboard.
*   **Goal:** Mission Accomplished.

---

## 4. Historical Context (Lessons from Research)
*   **Nested vs. Bare Metal:** Initial testing used nested Wayland windows (via Docker). Production goal is full-screen takeover via `systemd-nspawn`.
*   **Distro Specifics:** Fedora COSMIC requires F41+ due to library dependencies.
*   **System Integrity:** Standard `nspawn` templates may have restrictions (Read-Only/Ephemeral) that need dedicated overrides.

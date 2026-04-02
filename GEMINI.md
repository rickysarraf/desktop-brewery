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

### Phase 5: Extension Brewery (Sysext) - ACTIVE ✅
*   **Status:** Successfully generated and validated the first COSMIC Epoch 1.0.8 sysext image on real hardware.
*   **Innovation:** Integrated the **Tiered JIT Canary** mechanism. 
    *   **Relaxed (>=):** Allows core OS updates.
    *   **Strict (=):** Pins graphics/volatile stack for ABI safety.
*   **Integration:** COSMIC is now a "sidecar" desktop that can be hot-swapped onto the host OS via `systemd-sysext`.
*   **Next Milestone:** Automate the "Switchboard" toggle and GDM integration.

---

## 4. Historical Context (Lessons from Research)
*   **Nested vs. Bare Metal:** Initial testing used nested Wayland windows (via Docker). Production goal is full-screen takeover via `systemd-nspawn`.
*   **Distro Specifics:** Fedora COSMIC requires F41+ due to library dependencies.
---

## 5. Phase 1 Completion & Lessons Learned (2026-03-08)

### Phase 1 Status: ✅ COMPLETE
The "Brewery" pipeline is fully operational. All target images build, pass smoke tests, and are pushed to GHCR (`ghcr.io/rickysarraf/desktop-*`).

### Validation Results (Nested Weston)
| Image | Result | Lesson |
| :--- | :--- | :--- |
| **Fedora COSMIC** | ✅ Pass | Highly portable; runs well in isolated Wayland contexts. |
| **Pop!_OS COSMIC** | ✅ Pass | Robust; independent of host systemd for basic initialization. |
| **Arch KDE** | ❌ Fail | KWin 6 requires `systemd` and direct DRM nodes; fails in Docker. |
| **Ubuntu/Elementary**| ❌ Fail | `gnome-session` is deeply coupled with `systemd/logind`. |

### Key Findings for Phase 2
1.  **Systemd is the Gatekeeper:** Heavyweight DEs (KDE/GNOME) cannot be validated or run effectively in standard Docker containers without a full init system.
2.  **The Nspawn Pivot:** Phase 2 **must** transition from `docker` to `systemd-nspawn -b` (boot) to provide the necessary `logind` and `dbus` environment.
3.  **Socket Isolation:** The `XDG_RUNTIME_DIR` linking strategy used in `brewery-run.sh` works perfectly for nesting and should be carried forward.
4.  **Hardware Passthrough:** Direct `/dev/dri` and `/dev/input` access is required even for nested sessions to ensure GPU acceleration.

### Artifacts Created
*   `scripts/brewery-run.sh`: Universal container launcher with runtime isolation.
*   `scripts/brewery-nested.sh`: Sandbox runner for windowed validation using Weston.
*   `scripts/brewery-exclusive.sh`: (Draft) Foundation for full-screen hardware takeover.

---
## 6. Next Priority: Phase 2 (Base OS Proof of Concept)
*   **Target:** Minimal Debian + `systemd-nspawn` + `greetd`.
*   **Goal:** Boot a containerized DE as a primary session.


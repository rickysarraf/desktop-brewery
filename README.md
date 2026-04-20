# 🍻 Desktop Brewery: COSMIC for Debian

[![Desktop Brewery - Build Images](https://github.com/rickysarraf/desktop-brewery/actions/workflows/build-images.yml/badge.svg)](https://github.com/rickysarraf/desktop-brewery/actions/workflows/build-images.yml)

Welcome to the **Desktop Brewery** implementation of the [COSMIC Desktop Environment](https://github.com/pop-os/cosmic) for Debian.

This project uses an **"Atomic Switchboard"** approach to deliver a modern, rolling-release COSMIC DE experience on Debian Testing/Sid without polluting your host's root filesystem.

---

## 🏗️ Build Pipeline Overview

To ensure peak performance and stability, we maintain a automated, high-rigor build pipeline.

### What is built?
We build two primary `systemd-sysext` (System Extension) images:
- **`cosmic`**: The Core Desktop Environment (Compositor, Panel, Settings, Launcher).
- **`cosmic-utils`**: Essential community applications (Terminal, Files, Editor).
- **`cosmic-canary`**: A Just-In-Time (JIT) ABI safety package used to verify host compatibility.

### When is it built?
- **Weekly Cycle:** A full, fresh build is triggered every **Friday at 18:00 UTC**.
- **On-Demand:** Builds are also triggered automatically on every push to the `main` branch or via manual workflow dispatch.

### How is it built?
1.  **Isolated Base:** We use **Debian Testing** as the foundation, ensuring a modern but sane library stack.
2.  **Chroot Isolation:** Builds occur inside a sanitized **Debian Testing chroot** via `systemd-nspawn`. This prevents host contamination and ensures absolute reproducibility.
3.  **No-Cache Freshness:** All CI builds are executed with `no-cache: true` to ensure every release is built against the absolute latest state of Debian Testing.
4.  **OCI Delivery:** Binaries are extracted, sanitized, and packaged into OCI images delivered via the **GitHub Container Registry (GHCR)**.

---

## 🛠️ Helper Scripts

We have provided two primary helper scripts in the `bin/` directory to manage your COSMIC installation.

### 1. `cosmic-update`
This script automates the retrieval and sanitization of the COSMIC extensions from GHCR.

- **Pristine Host Mode:** It unmerges any active extensions before updating to ensure your `/usr` remains pristine.
- **Sanitization:** It automatically removes conflicting host binaries (like `env`, `sh`, `bash`) from the extension to prevent recursion loops.
- **Usage:**
  ```bash
  # Update just the Core DE
  ./bin/cosmic-update

  # Update the full stack (Core + Community Utils)
  ./bin/cosmic-update utils
  ```

### 2. `cosmic-toggle`
This script manages the lifecycle of the COSMIC extension on your host.

- **ABI Safety Check:** Before activation, it verifies the **JIT Canary** (`cosmic-canary`) is installed and healthy to ensure your host's libraries are compatible with the extension.
- **Usage:**
  ```bash
  # Activate COSMIC
  ./bin/cosmic-toggle on

  # Revert to stock Debian
  ./bin/cosmic-toggle off

  # Check current state
  ./bin/cosmic-toggle status
  ```

---

## 🛡️ Safety: The JIT Canary

Because COSMIC is built in an isolated chroot, there is a risk of **ABI Drift** if your host system lags too far behind the build base (Debian Testing).

To mitigate this, we use the **`cosmic-canary`** package.
- It acts as a Just-In-Time (JIT) dependency check.
- If your host system has unmet dependencies or library versions that would cause COSMIC to crash, the `cosmic-toggle` script will detect the failure and refuse to merge the extension.

---

## 📦 Getting Started

### 1. Prerequisites
- **systemd** >= 248
- **Docker** (required for `cosmic-update` to pull images)
- **Debian Testing or Sid** host.

### 2. Install the Canary
Install the `cosmic-canary` `.deb` package provided in our [Releases](https://github.com/rickysarraf/desktop-brewery/releases) page.

### 3. Fetch and Activate
```bash
# Clone this repository
git clone https://github.com/rickysarraf/desktop-brewery.git
cd desktop-brewery

# Pull the latest weekly build
./bin/cosmic-update utils

# Activate the session
./bin/cosmic-toggle on
```

### 4. Login
Log out of your current session and select **COSMIC** from your Display Manager (GDM, SDDM, or greetd).

---

## 🤝 Contributing
For developers looking to modify the build recipes or chroot logic, please refer to the subdirectories (e.g., `debian-testing-cosmic-sysext`). Contributions to the `justfile` logic or documentation are highly encouraged!

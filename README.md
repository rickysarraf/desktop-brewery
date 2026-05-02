# 🍻 Desktop Brewery

[![Desktop Brewery - Build Images](https://github.com/rickysarraf/desktop-brewery/actions/workflows/build-images.yml/badge.svg)](https://github.com/rickysarraf/desktop-brewery/actions/workflows/build-images.yml)

Welcome to the **Desktop Brewery**. This project provides a collection of Docker-based "recipes" and orchestration tools to build, test, and run various Desktop Environments in isolation.

---

## 🏗️ Architecture

The Brewery uses a containerized approach to deliver modern desktop experiences without polluting your host's root filesystem.

### Supported Distributions & Desktops
We maintain recipes for several combinations:
- **Fedora COSMIC**
- **Pop!_OS COSMIC**
- **Debian GNOME/KDE**
- **Ubuntu Stable**
- **Arch KDE**
- **Elementary Pantheon**

---

## 🛠️ Helper Scripts

We provide several scripts in the `scripts/` directory to manage and run these containerized desktops:

### 1. `brewery-run.sh`
Launches a containerized desktop session nested within your current Wayland session.
```bash
./scripts/brewery-run.sh ghcr.io/rickysarraf/fedora-cosmic cosmic-session
```

### 2. `brewery-nested.sh`
Helper for nested session configuration.

---

## 📦 Building Locally

You can build any of the images locally using Docker:
```bash
docker build -t my-desktop ./fedora-cosmic
```

---

## 🤝 Contributing

Contributions of new desktop recipes or improvements to the orchestration scripts are welcome! Please ensure that new recipes follow the "Pristine Host" principle.

For the **Debian COSMIC** specialized project, please see the [debian-cosmic](https://github.com/rickysarraf/debian-cosmic) repository.

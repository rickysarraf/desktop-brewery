# Project: Desktop Brewery

## 1. Core Mandates
- **Distro Agnostic:** Maintain recipes for multiple distributions and desktop environments.
- **Isolation:** All sessions must run in containers to protect the host OS.
- **Tooling:** Maintain the `scripts/` directory for orchestration.

## 2. History & Sovereignty
- **Debian COSMIC:** Previously the primary focus, it has been carved out into its own standalone project: [debian-cosmic](https://github.com/rickysarraf/debian-cosmic).
- **Current Focus:** General desktop environment orchestration and testing.

## 3. Workflows
- **Image Building:** Managed via the `build-images.yml` workflow.
- **Testing:** Use `scripts/brewery-run.sh` for local nested testing.

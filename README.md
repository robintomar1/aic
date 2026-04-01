# AIC Docker Setup

Docker-based development environment for the [Intrinsic AIC](https://github.com/intrinsic-dev/aic) project.
Runs on Ubuntu 22.04 (or any Docker-capable host) without needing Ubuntu 24.04 natively.

## Prerequisites

- [Docker Engine](https://docs.docker.com/engine/install/) with [post-install steps](https://docs.docker.com/engine/install/linux-postinstall/) (non-root access)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (for GPU support)
- NVIDIA GPU with 8GB+ VRAM recommended (RTX 2070+)

## Services

| Service | Image | Purpose |
|---------|-------|---------|
| `dev`   | `osrf/ros:kilted-desktop` + Pixi | Development container (ROS 2 Kilted + Ubuntu 24.04) |
| `eval`  | `ghcr.io/intrinsic-dev/aic/aic_eval` | Evaluation / simulation environment (Gazebo + rviz2) |

Both containers use `network_mode: host` for Zenoh-based ROS 2 communication.

## Quick Start

### 1. Clone the repo (with submodule)

```bash
git clone --recurse-submodules git@github.com:robintomar1/aic.git
cd aic
```

If already cloned without submodules:

```bash
git submodule update --init --recursive
```

### 2. Build and start containers

```bash
# Allow X11 forwarding (for GUI apps like Gazebo, rviz2)
xhost +local:docker

# Build dev image and start both containers
docker compose up -d --build
```

### 3. Install Pixi dependencies

```bash
docker compose exec dev bash
cd src/aic
pixi install
```

### 4. Run an example policy

In a separate terminal (while eval container is running):

```bash
docker compose exec dev bash
cd src/aic
pixi run ros2 run aic_model aic_model --ros-args -p use_sim_time:=true \
  -p policy:=aic_example_policies.ros.WaveArm
```

## Persistence

- **Source code** (`./workspace/`) — bind-mounted, persists on host
- **Pixi environments** (`./workspace/aic/.pixi/`) — persists on host (inside bind mount)
- **apt packages** — baked into the Docker image via `Dockerfile`. Add new packages there and rebuild:
  ```bash
  docker compose up -d --build
  ```

## Stopping

```bash
# Stop containers
docker compose down

# Stop and remove volumes
docker compose down -v
```

## No GPU?

Remove the `deploy.resources` block from the `eval` service in `docker-compose.yml`.

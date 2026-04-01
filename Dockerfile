FROM osrf/ros:kilted-desktop

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    vim \
    build-essential \
    cmake \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Pixi
RUN curl -fsSL https://pixi.sh/install.sh | sh
ENV PATH="/root/.pixi/bin:${PATH}"

# Source ROS setup in bashrc
RUN echo "source /opt/ros/kilted/setup.bash" >> /root/.bashrc

WORKDIR /root/ws_aic

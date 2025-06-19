FROM ubuntu:latest AS osbase

LABEL maintainer="nxt5656 <nxt5656@live.cn>"
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.description="ComfyUI容器镜像"
LABEL org.opencontainers.image.source=https://github.com/nxt5656/ComfyUIDockerImages
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
        software-properties-common \
        curl \
        ca-certificates \
        gnupg \
        lsb-release \
        build-essential \
        wget \
        git \
        && rm -rf /var/lib/apt/lists/*
FROM osbase AS cudabase
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
RUN mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
RUN wget https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda-repo-ubuntu2404-12-8-local_12.8.1-570.124.06-1_amd64.deb
RUN dpkg -i cuda-repo-ubuntu2404-12-8-local_12.8.1-570.124.06-1_amd64.deb
RUN cp /var/cuda-repo-ubuntu2404-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
RUN apt update && apt install -y --no-install-recommends cuda-toolkit-12-8

FROM cudabase AS pythonbase
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y --no-install-recommends \
    python3.12 python3.12-venv python3.12-dev && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 && \
    python --version && pip3 install --break-system-packages --no-cache-dir --upgrade pip setuptools


FROM ubuntu:latest AS os-base

LABEL maintainer="nxt5656 <nxt5656@live.cn>"
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.description="ComfyUI容器镜像"
LABEL org.opencontainers.image.source=https://github.com/nxt5656/ComfyUIDockerImages
ENV DEBIAN_FRONTEND=noninteractive

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
FROM os-base AS cuda-base
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin && \
    mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2404-12-8-local_12.8.0-1_amd64.deb && \
    dpkg -i cuda-repo-ubuntu2404-12-8-local_12.8.0-1_amd64.deb && \
    cp /var/cuda-repo-ubuntu2404-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/ && \
    apt-get update && apt-get install -y --no-install-recommends cuda && \
    rm -rf /var/lib/apt/lists/* cuda-repo-ubuntu2404-12-8-local_12.8.0-1_amd64.deb

FROM cuda-base AS python-base
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y --no-install-recommends \
    python3.12 python3.12-venv python3.12-dev python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 && \
    python --version && pip3 install --no-cache-dir --upgrade pip setuptools


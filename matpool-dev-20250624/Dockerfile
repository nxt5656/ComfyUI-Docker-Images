FROM ubuntu:latest AS base_os

LABEL maintainer="nxt5656 <nxt5656@live.cn>"
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.description="ComfyUI容器镜像"
LABEL org.opencontainers.image.source=https://github.com/nxt5656/ComfyUIDockerImages

ENV DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/cache/apt \
    apt update && \
    apt install -y python3.12 python3-pip python3-venv && \
    rm -f /var/cache/apt/archives/lock

RUN python3 -m venv /opt/venv
RUN /opt/venv/bin/pip install --upgrade pip
RUN --mount=type=cache,target=/home/root/.cache/pip \
    /opt/venv/bin/pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128
RUN --mount=type=cache,target=/root/.cache/pip \
    /opt/venv/bin/pip install \
        -r https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt

FROM ubuntu:latest AS comfyui_runner
RUN --mount=type=cache,target=/var/cache/apt \
    apt update && \
    apt install -y git
COPY --from=base_os /opt/venv /opt/venv
COPY runner-scripts/.  /runner-scripts/
USER root
VOLUME /home/root
WORKDIR /home/root
EXPOSE 8188

ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
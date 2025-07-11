FROM ubuntu:latest AS base_os

LABEL maintainer="nxt5656 <nxt5656@live.cn>"
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.description="ComfyUI容器镜像"
LABEL org.opencontainers.image.source=https://github.com/nxt5656/ComfyUIDockerImages

ENV DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/cache/apt \
    apt update && \
    apt install -y python3.12 python3-pip python3-venv
RUN python3 -m venv /opt/venv
RUN /opt/venv/bin/pip install --upgrade pip
RUN --mount=type=cache,target=/root/.cache/pip \
    /opt/venv/bin/pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128
RUN --mount=type=cache,target=/root/.cache/pip \
    /opt/venv/bin/pip install \
    -r https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt \
    -r https://gh-proxy.com/https://github.com/ltdrdata/ComfyUI-Manager/raw/refs/heads/main/requirements.txt \
    nvitop && \
    pip list

FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

LABEL maintainer="nxt5656 <nxt5656@live.cn>"
RUN apt update && \
    apt install -y  \
    git  \
    python3.12 python3-pip python3-venv  \
    easy-rsa \
    openssh-server \
    passwd \
    supervisor \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mkdir -p /var/run/sshd && \
    ssh-keygen -A && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "root:passwd123" | chpasswd
RUN echo "PATH=/opt/venv/bin:${PATH}" >> /etc/profile
COPY --from=base_os /opt/venv /opt/venv
COPY runner-scripts/.  /runner-scripts/
USER root
VOLUME /root
WORKDIR /root



ENV CLI_ARGS=""
CMD ["supervisord","-c","/runner-scripts/supervisord.conf"]
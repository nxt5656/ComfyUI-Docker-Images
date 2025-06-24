FROM opensuse/tumbleweed:latest AS zypper-base

LABEL maintainer="nxt5656 <nxt5656@live.cn>"
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.description="ComfyUI容器镜像"
LABEL org.opencontainers.image.source=https://github.com/nxt5656/ComfyUIDockerImages
ENV DEBIAN_FRONTEND=noninteractive

RUN set -eu

WORKDIR /home/root
RUN --mount=type=cache,target=/var/cache/zypp \
    zypper modifyrepo --disable --all \
    && zypper addrepo --check --refresh --gpgcheck \
        'https://mirror.nju.edu.cn/opensuse/tumbleweed/repo/oss/' mirror-oss \
    && zypper addrepo --check --refresh --gpgcheck \
        'https://mirror.nju.edu.cn/opensuse/tumbleweed/repo/non-oss/' mirror-non-oss \
    && zypper addrepo --check --refresh --priority 90 \
        'https://mirror.nju.edu.cn/packman/suse/openSUSE_Tumbleweed/Essentials/' mirror-packman-essentials \
    && zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python312-devel \
python312-pip \
python312-wheel \
python312-setuptools \
python312-Cython \
python312-py-build-cmake \
python312-aiohttp \
python312-dbm \
python312-ffmpeg-python \
python312-GitPython \
python312-httpx \
python312-joblib \
python312-lark \
python312-matplotlib \
python312-mpmath \
python312-numba-devel \
python312-numpy1 \
python312-onnx \
python312-opencv \
python312-pandas \
python312-qrcode \
python312-rich \
python312-scikit-build \
python312-scikit-build-core-pyproject \
python312-scikit-image \
python312-scikit-learn \
python312-scipy \
python312-svglib \
python312-tqdm \
    && rm /usr/lib64/python3.12/EXTERNALLY-MANAGED \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 100

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
Mesa-libGL1 \
Mesa-libEGL-devel \
libgthread-2_0-0 \
make \
ninja \
git \
aria2 \
fish \
fd \
vim \
opencv \
opencv-devel \
ffmpeg \
x264 \
x265 \
google-noto-sans-fonts \
google-noto-sans-cjk-fonts \
google-noto-coloremoji-fonts

FROM zypper-base AS pip-base
ENV LD_PRELOAD=/usr/lib64/libjpeg.so.8

################################################################################
# GCC 13 
# 与 CUDA 12.4 兼容

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
gcc13 \
gcc13-c++ \
cpp13 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-13 90 \
    && update-alternatives --install /usr/bin/cc  cc  /usr/bin/gcc-13 90 \
    && update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-13 90 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 90 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 90 \
    && update-alternatives --install /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-13 90 \
    && update-alternatives --install /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-13 90 \
    && update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-13 90 \
    && update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-13 90 \
    && update-alternatives --install /usr/bin/gcov-dump gcov-dump /usr/bin/gcov-dump-13 90 \
    && update-alternatives --install /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-13 90 

################################################################################
# 配置使用国内源，安装 Python 包

ENV PIP_INDEX_URL="https://mirrors.cernet.edu.cn/pypi/web/simple"

# PyTorch, xFormers
# 拆分安装步骤，使生成的镜像文件分为更多更小的层，减少单层下载大小。
RUN --mount=type=cache,target=/home/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools \
    && pip install \
        --dry-run xformers torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu128
RUN --mount=type=cache,target=/home/root/.cache/pip \
    pip install \
        --no-deps xformers torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu128


RUN --mount=type=cache,target=/home/root/.cache/pip \
    pip install \
        xformers torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu128


# 绑定环境变量 (依赖库 .so 文件)
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/local/lib64/python3.12/site-packages/torch/lib\
:/usr/local/lib/python3.12/site-packages/cusparselt/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cublas/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cuda_cupti/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cuda_nvrtc/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cuda_runtime/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cudnn/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cufft/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cufile/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/curand/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cusolver/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cusparse/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/nccl/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/nvjitlink/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/nvtx/lib"

FROM  pip-base AS builder-base
COPY builder-scripts/.  /builder-scripts/

# 安装 ComfyUI 及扩展的依赖项
RUN --mount=type=cache,target=/home/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak3.txt

RUN --mount=type=cache,target=/home/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak5.txt

RUN --mount=type=cache,target=/home/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak7.txt


RUN --mount=type=cache,target=/home/root/.cache/pip \
    pip install \
        -r https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt \
        -r https://github.com/ltdrdata/ComfyUI-Manager/raw/refs/heads/main/requirements.txt \
    && pip list


ENV HF_ENDPOINT=https://hf-mirror.com


RUN du -ah /home/root \
    && rm -rf /home/root/* \
    && rm -rf /home/root/.[^.]* /root/.??*

COPY runner-scripts/.  /runner-scripts/

USER root
VOLUME /home/root
WORKDIR /home/root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
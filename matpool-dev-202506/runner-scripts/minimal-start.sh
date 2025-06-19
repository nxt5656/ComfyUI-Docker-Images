#!/bin/bash

# 最小化启动脚本

set -e

# 运行用户的配置代理脚本
cd /home/root
if [ ! -f "/home/root/user-scripts/set-proxy.sh" ] ; then
    mkdir -p /home/root/user-scripts
    cp /runner-scripts/set-proxy.sh.example /home/root/user-scripts/set-proxy.sh
else
    echo "[INFO] 执行配置代理脚本……"

    chmod +x /home/root/user-scripts/set-proxy.sh
    source /home/root/user-scripts/set-proxy.sh
fi ;

# 下载 ComfyUI 与 Manager，不下载扩展，不下载模型文件
cd /home/root
if [ ! -f "/home/root/.download-complete" ] ; then
    echo "########################################"
    echo "[INFO] 下载 ComfyUI & Manager..."
    echo "########################################"

    set +e

    git clone https://gh-proxy.com/https://github.com/comfyanonymous/ComfyUI.git || git -C ComfyUI pull --ff-only
    cd /home/root/ComfyUI
    git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"

    cd /home/root/ComfyUI/custom_nodes
    git clone --depth=1 https://gh-proxy.com/https://github.com/ltdrdata/ComfyUI-Manager.git || git -C ComfyUI-Manager pull --ff-only

    set -e

    touch /home/root/.download-complete
fi ;

# 运行用户的预启动脚本
cd /home/root
if [ ! -f "/home/root/user-scripts/pre-start.sh" ] ; then
    mkdir -p /home/root/user-scripts
    cp /runner-scripts/pre-start.sh.example /home/root/user-scripts/pre-start.sh
else
    echo "[INFO] 执行预启动脚本……"

    chmod +x /home/root/user-scripts/pre-start.sh
    source /home/root/user-scripts/pre-start.sh
fi ;


echo "########################################"
echo "[INFO] 启动 ComfyUI..."
echo "########################################"

# 使得 .pyc 缓存文件集中保存
export PYTHONPYCACHEPREFIX="/home/root/.cache/pycache"
# 使得 PIP 安装新包到 /home/root/.local
export PIP_USER=true
# 添加上述路径到 PATH
export PATH="${PATH}:/home/root/.local/bin"
# 不再显示警报 [WARNING: Running pip as the 'root' user]
export PIP_ROOT_USER_ACTION=ignore

cd /home/root

python3 /home/root/ComfyUI/main.py --listen --port 8188 ${CLI_ARGS}
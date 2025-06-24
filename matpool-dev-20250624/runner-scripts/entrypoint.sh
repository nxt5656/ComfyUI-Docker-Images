# 下载 ComfyUI 与 Manager，不下载扩展，不下载模型文件
cd /root
if [ ! -f "/root/.download-complete" ] ; then
    echo "########################################"
    echo "[INFO] 下载 ComfyUI & Manager..."
    echo "########################################"

    set +e

    git clone https://github.com/comfyanonymous/ComfyUI.git || git -C ComfyUI pull --ff-only
    cd /root/ComfyUI
    git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"

    cd /root/ComfyUI/custom_nodes
    git clone --depth=1 https://github.com/ltdrdata/ComfyUI-Manager.git || git -C ComfyUI-Manager pull --ff-only

    set -e

    touch /root/.download-complete
fi ;

echo "########################################"
echo "[INFO] 启动 ComfyUI..."
echo "########################################"

# 使得 .pyc 缓存文件集中保存
export PYTHONPYCACHEPREFIX="/root/.cache/pycache"
# 使得 PIP 安装新包到 /root/.local
export PIP_USER=true
# 添加上述路径到 PATH
export PATH="${PATH}:/root/.local/bin"
# 不再显示警报 [WARNING: Running pip as the 'root' user]
export PIP_ROOT_USER_ACTION=ignore

cd /root

/opt/venv/bin/python3 ./ComfyUI/main.py --listen --port 8188 ${CLI_ARGS}
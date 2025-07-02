#!/bin/bash

# 目标白名单文件路径
WHITELIST_FILE="/etc/nginx/whitelist.conf"

# 检查 ACCESS_IP_LIST 是否存在
if [ -z "$ACCESS_IP_LIST" ]; then
  echo "环境变量 ACCESS_IP_LIST 未设置或为空"
  exit 1
fi

# 创建 whitelist.conf 文件
{
  # 使用 IFS 分割 IP 列表
  IFS=',' read -ra IP_LIST <<< "$ACCESS_IP_LIST"
  for ip in "${IP_LIST[@]}"; do
    echo "allow $ip;"
  done
  echo "allow 127.0.0.1;"
  echo "deny all;"
} > "$WHITELIST_FILE"

echo "白名单已写入 $WHITELIST_FILE"
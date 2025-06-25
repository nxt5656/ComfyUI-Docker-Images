#!/bin/bash

# 检查环境变量 OS_PASSWD 是否为空
if [ -z "$OS_PASSWD" ]; then
    echo "环境变量 OS_PASSWD 未设置，跳过 root 密码修改。"
    exit 0
fi

# 修改 root 用户密码
echo "root:$OS_PASSWD" | chpasswd

# 检查命令是否成功
if [ $? -eq 0 ]; then
    echo "root 密码已成功修改。"
else
    echo "root 密码修改失败。"
    exit 1
fi
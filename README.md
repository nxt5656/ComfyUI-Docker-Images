# comfyui
comfyui镜像


## 阿里云函数计算专用镜像

[官方文档](https://help.aliyun.com/zh/functioncompute/fc-3-0)


## 矩池云专用镜像

要使用自有镜像,需要联系售后开通 

[官方文档](https://matpool.com/supports/doc-quick-start/)

### matpool-dev-202506 版本

|   依赖   |   版本    |    说明    |
|:------:|:-------:|:--------:|
|   OS   | ubuntu: |          |
|  CUDA  |  12.4   |          |
| Python |  3.12   | |


### 环境变量
|   变量名   | 默认值 |     说明      |
|:------:|:---:|:-----------:|
|   OS_PASSWD   |  无  |  操作系统密码,可空  |
|   ACCESS_IP_LIST   |  无  | 可访问白名单,以逗号分割 |

### 开发计划
1. 支持白名单调用 
2. 支持模型同步或自动下载
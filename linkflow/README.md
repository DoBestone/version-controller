# LinkFlow

智能链接管理与流量分发平台。

## 系统要求

- Linux (amd64 / arm64)
- MySQL 8.0+
- 开放端口: 9110(后端)、9100(前端,或 nginx 代理)

## 一键安装

```bash
bash <(curl -sL https://raw.githubusercontent.com/DoBestone/version-controller/main/linkflow/install.sh)
```

安装脚本会自动:
1. 检测系统架构(amd64/arm64)
2. 下载最新版后端 + 前端
3. 创建目录结构和 systemd 服务
4. 启动服务

## 一键更新

```bash
bash <(curl -sL https://raw.githubusercontent.com/DoBestone/version-controller/main/linkflow/update.sh)
```

更新脚本会自动:
1. 查询最新版本号
2. 下载新版后端 + 前端
3. 备份旧版
4. 替换并重启服务

## 版本历史

查看所有版本: [Releases](https://github.com/DoBestone/version-controller/releases?q=linkflow)

## 手动安装

如果不想用一键脚本:

```bash
# 1. 下载
VERSION="1.0.0"
wget https://github.com/DoBestone/version-controller/releases/download/linkflow-v${VERSION}/linkflow-linux-amd64.tar.gz
wget https://github.com/DoBestone/version-controller/releases/download/linkflow-v${VERSION}/linkflow-frontend.tar.gz

# 2. 解压
mkdir -p /opt/linkflow
tar -xzf linkflow-linux-amd64.tar.gz -C /opt/linkflow/
tar -xzf linkflow-frontend.tar.gz -C /opt/linkflow/web/

# 3. 配置并启动(参考项目文档)
```

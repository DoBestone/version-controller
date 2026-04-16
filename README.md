# DoBestone 产品发布中心

预编译产物下载 + 一键安装/更新脚本。所有产品从这里获取最新版本，无需编译环境。

---

## 产品列表

| 产品 | 说明 | 最新版本 | 安装 |
|------|------|---------|------|
| [LinkFlow](./linkflow/) | 智能链接管理与像素追踪平台 | [![](https://img.shields.io/github/v/release/DoBestone/version-controller?filter=linkflow-*&label=)](https://github.com/DoBestone/version-controller/releases?q=linkflow) | [一键安装](./linkflow/README.md) |

---

## 快速开始

### 一键安装

```bash
# LinkFlow
bash <(curl -sL https://raw.githubusercontent.com/DoBestone/version-controller/main/linkflow/install.sh)
```

交互式安装向导，自动配置 MySQL、Nginx、SSL、systemd 服务。

### 一键更新

```bash
# 在安装目录下执行
cd /opt/linkflow  # 或你的安装目录
bash <(curl -sL https://raw.githubusercontent.com/DoBestone/version-controller/main/linkflow/update.sh)
```

自动备份旧版 → 下载新版 → 替换 → 重启服务。

### 手动下载

```bash
# 下载指定版本（公开仓库，无需认证）
VERSION="1.0.5"
wget https://github.com/DoBestone/version-controller/releases/download/linkflow-v${VERSION}/linkflow-backend-linux-amd64.tar.gz
wget https://github.com/DoBestone/version-controller/releases/download/linkflow-v${VERSION}/linkflow-frontend.tar.gz
```

---

## 产物命名规则

```
{产品}-backend-linux-{arch}.tar.gz    # Go 后端二进制
{产品}-frontend.tar.gz                # Vue 前端静态文件
```

支持架构: `amd64` (x86_64) / `arm64` (aarch64)

---

## 仓库结构

```
version-controller/
├── README.md              ← 本文件
├── linkflow/
│   ├── README.md          ← LinkFlow 安装说明
│   ├── install.sh         ← 一键安装脚本
│   └── update.sh          ← 一键更新脚本
└── Releases               ← 编译产物（通过 GitHub Releases 管理）
```

# LinkFlow

智能链接管理与像素追踪平台。短链创建、流量分发、斗篷过滤、像素转化追踪、访客分析一站式解决。

## 功能

- **短链管理** — 创建/编辑/暂停，自定义短码，批量操作
- **流量分发** — 按权重分配到多个目标 URL，A/B 测试
- **斗篷规则** — 按国家/设备/浏览器/IP 类型/爬虫过滤流量
- **像素追踪** — 独立转化追踪，对齐 Meta Pixel / GA4 设计
- **访客日志** — 完整访客信息，设备指纹 AI 识别，17 种浏览器识别
- **流量分析** — 点击趋势、地区分布、设备分布、来源分析
- **智能情报** — 运营商 AI 分类、设备指纹识别、IP 黑名单
- **在线更新** — 后台一键检查/执行更新，强制更新机制

## 技术栈

| 层 | 技术 |
|---|---|
| 后端 | Go + Gin + GORM + MySQL |
| 前端 | Vue 3 + TypeScript + Element Plus + ECharts |
| 高并发 | 异步批量写、内存计数器、两级缓存、独立访客追踪 |

## 系统要求

- Linux (amd64 / arm64)
- MySQL 8.0+
- 1 核 1G 起步，推荐 2 核 2G

## 一键安装

```bash
bash <(curl -sL https://raw.githubusercontent.com/DoBestone/version-controller/main/linkflow/install.sh)
```

交互式安装向导:
1. 选择安装目录和端口
2. 自动安装/配置 MySQL（或连接已有数据库）
3. 可选配置 Nginx 反向代理 + Let's Encrypt SSL
4. 配置 systemd 开机自启
5. 下载最新版后端 + 前端

默认管理员: `admin` / `admin123`（首次登录后请立即修改）

## 一键更新

```bash
cd /opt/linkflow  # 你的安装目录
bash <(curl -sL https://raw.githubusercontent.com/DoBestone/version-controller/main/linkflow/update.sh)
```

或在管理后台 → 系统设置 → 系统更新 → 点击「立即更新」。

## 手动安装

```bash
VERSION="1.0.5"
ARCH="amd64"  # 或 arm64

# 下载
wget https://github.com/DoBestone/version-controller/releases/download/linkflow-v${VERSION}/linkflow-backend-linux-${ARCH}.tar.gz
wget https://github.com/DoBestone/version-controller/releases/download/linkflow-v${VERSION}/linkflow-frontend.tar.gz

# 解压
mkdir -p /opt/linkflow
tar -xzf linkflow-backend-linux-${ARCH}.tar.gz -C /opt/linkflow/
tar -xzf linkflow-frontend.tar.gz -C /opt/linkflow/
chmod +x /opt/linkflow/linkflow-api

# 配置
cat > /opt/linkflow/.env <<EOF
PORT=9110
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=linkflow
DB_PASS=your_password
DB_NAME=linkflow
JWT_SECRET=$(openssl rand -hex 16)
GIN_MODE=release
EOF

# 启动
cd /opt/linkflow && ./linkflow-api
```

## 版本历史

[查看所有版本](https://github.com/DoBestone/version-controller/releases?q=linkflow)

## 端口说明

| 端口 | 用途 |
|------|------|
| 9110 | 后端 API + 短链跳转 + 像素采集 |

后端内置前端静态文件服务，单端口即可运行。配合 Nginx 反代可实现域名 + SSL。

## 路由映射

```
/                    → 管理后台
/:shortcode          → 短链跳转（302）
/pixel.js            → 像素 JS SDK
/p/:token.gif        → 像素图片采集
/api/c/:token        → 像素 S2S 采集
/api/admin/*         → 管理 API
```

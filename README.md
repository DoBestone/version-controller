# version-controller

产品线统一版本控制器。

- **编译产物** → Release(按 tag 区分项目和版本)
- **安装/更新脚本** → 各项目目录
- **源码** → 不存(在各项目的私密仓库)

---

## 项目列表

| 项目 | 说明 | 安装文档 |
|---|---|---|
| [linkflow](./linkflow/) | 智能链接管理与流量分发平台 | [安装说明](./linkflow/README.md) |

> 新项目接入时在此表格添加一行,并创建对应目录。

---

## 快速安装

```bash
# 一键安装(以 linkflow 为例)
bash <(curl -sL https://raw.githubusercontent.com/DoBestone/version-controller/main/linkflow/install.sh)
```

## 快速更新

```bash
# 一键更新到最新版
bash <(curl -sL https://raw.githubusercontent.com/DoBestone/version-controller/main/linkflow/update.sh)
```

## 手动下载

```bash
# 下载指定版本编译产物(公开,无需认证)
wget https://github.com/DoBestone/version-controller/releases/download/{project}-v{version}/{project}-linux-amd64.tar.gz
wget https://github.com/DoBestone/version-controller/releases/download/{project}-v{version}/{project}-frontend.tar.gz
```

#!/bin/bash
# LinkFlow 一键安装脚本
# 用法: bash <(curl -sL https://raw.githubusercontent.com/DoBestone/version-controller/main/linkflow/install.sh)

set -e

PROJECT="linkflow"
REPO="DoBestone/version-controller"
INSTALL_DIR="/opt/linkflow"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# 检测架构
detect_arch() {
    local arch=$(uname -m)
    case "$arch" in
        x86_64)  echo "amd64" ;;
        aarch64) echo "arm64" ;;
        armv7l)  echo "arm" ;;
        *)       error "不支持的架构: $arch" ;;
    esac
}

# 获取最新版本号
get_latest_version() {
    local latest=$(curl -sL "https://api.github.com/repos/${REPO}/releases" \
        | grep -o "\"tag_name\":\"${PROJECT}-v[^\"]*\"" \
        | head -1 \
        | sed "s/\"tag_name\":\"${PROJECT}-v//;s/\"//")

    if [ -z "$latest" ]; then
        error "无法获取最新版本,请检查网络"
    fi
    echo "$latest"
}

# 下载文件
download() {
    local version=$1
    local tag="${PROJECT}-v${version}"
    local arch=$(detect_arch)
    local base_url="https://github.com/${REPO}/releases/download/${tag}"

    info "下载后端 (${arch})..."
    curl -sL -o /tmp/${PROJECT}-backend.tar.gz "${base_url}/${PROJECT}-linux-${arch}.tar.gz" || error "后端下载失败"

    info "下载前端..."
    curl -sL -o /tmp/${PROJECT}-frontend.tar.gz "${base_url}/${PROJECT}-frontend.tar.gz" || error "前端下载失败"
}

# 安装
install() {
    local version=$1

    info "创建目录 ${INSTALL_DIR}"
    mkdir -p ${INSTALL_DIR}/{bin,web,data,logs}

    info "解压后端..."
    tar -xzf /tmp/${PROJECT}-backend.tar.gz -C ${INSTALL_DIR}/bin/
    chmod +x ${INSTALL_DIR}/bin/*

    info "解压前端..."
    tar -xzf /tmp/${PROJECT}-frontend.tar.gz -C ${INSTALL_DIR}/web/

    # 记录版本号
    echo "$version" > ${INSTALL_DIR}/.version

    info "清理临时文件..."
    rm -f /tmp/${PROJECT}-backend.tar.gz /tmp/${PROJECT}-frontend.tar.gz
}

# 主流程
main() {
    echo "==============================="
    echo "  LinkFlow 安装程序"
    echo "==============================="
    echo ""

    # 检查 root
    if [ "$(id -u)" -ne 0 ]; then
        error "请使用 root 用户运行: sudo bash install.sh"
    fi

    local arch=$(detect_arch)
    info "系统架构: ${arch}"

    local version=$(get_latest_version)
    info "最新版本: v${version}"

    if [ -d "${INSTALL_DIR}" ] && [ -f "${INSTALL_DIR}/.version" ]; then
        local current=$(cat ${INSTALL_DIR}/.version)
        warn "检测到已安装版本 v${current},如需更新请使用 update.sh"
        read -p "是否覆盖安装? (y/N): " confirm
        [ "$confirm" != "y" ] && [ "$confirm" != "Y" ] && exit 0
    fi

    download "$version"
    install "$version"

    echo ""
    info "安装完成! 版本: v${version}"
    info "安装目录: ${INSTALL_DIR}"
    info "后端位置: ${INSTALL_DIR}/bin/"
    info "前端位置: ${INSTALL_DIR}/web/"
    echo ""
    info "请根据项目文档配置数据库和环境变量后启动服务"
}

main "$@"

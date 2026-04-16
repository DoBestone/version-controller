#!/bin/bash
# LinkFlow 一键更新脚本
# 用法: bash <(curl -sL https://raw.githubusercontent.com/DoBestone/version-controller/main/linkflow/update.sh)

set -e

PROJECT="linkflow"
REPO="DoBestone/version-controller"
INSTALL_DIR="/opt/linkflow"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

detect_arch() {
    local arch=$(uname -m)
    case "$arch" in
        x86_64)  echo "amd64" ;;
        aarch64) echo "arm64" ;;
        armv7l)  echo "arm" ;;
        *)       error "不支持的架构: $arch" ;;
    esac
}

get_latest_version() {
    local latest=$(curl -sL "https://api.github.com/repos/${REPO}/releases" \
        | grep -o "\"tag_name\":\"${PROJECT}-v[^\"]*\"" \
        | head -1 \
        | sed "s/\"tag_name\":\"${PROJECT}-v//;s/\"//")

    if [ -z "$latest" ]; then
        error "无法获取最新版本"
    fi
    echo "$latest"
}

main() {
    echo "==============================="
    echo "  LinkFlow 更新程序"
    echo "==============================="
    echo ""

    if [ "$(id -u)" -ne 0 ]; then
        error "请使用 root 用户运行"
    fi

    if [ ! -d "${INSTALL_DIR}" ]; then
        error "未检测到安装目录 ${INSTALL_DIR},请先运行 install.sh"
    fi

    local current="未知"
    [ -f "${INSTALL_DIR}/.version" ] && current=$(cat ${INSTALL_DIR}/.version)
    info "当前版本: v${current}"

    local latest=$(get_latest_version)
    info "最新版本: v${latest}"

    if [ "$current" = "$latest" ]; then
        info "已是最新版本,无需更新"
        exit 0
    fi

    local arch=$(detect_arch)
    local tag="${PROJECT}-v${latest}"
    local base_url="https://github.com/${REPO}/releases/download/${tag}"

    # 备份
    local backup_dir="${INSTALL_DIR}/backup/v${current}_$(date +%Y%m%d%H%M%S)"
    info "备份当前版本到 ${backup_dir}"
    mkdir -p "$backup_dir"
    [ -d "${INSTALL_DIR}/bin" ] && cp -r ${INSTALL_DIR}/bin "$backup_dir/"
    [ -d "${INSTALL_DIR}/web" ] && cp -r ${INSTALL_DIR}/web "$backup_dir/"

    # 下载
    info "下载后端 (${arch})..."
    curl -sL -o /tmp/${PROJECT}-backend.tar.gz "${base_url}/${PROJECT}-linux-${arch}.tar.gz" || error "后端下载失败"

    info "下载前端..."
    curl -sL -o /tmp/${PROJECT}-frontend.tar.gz "${base_url}/${PROJECT}-frontend.tar.gz" || error "前端下载失败"

    # 停止服务(如果有 systemd)
    if systemctl is-active --quiet ${PROJECT} 2>/dev/null; then
        info "停止服务..."
        systemctl stop ${PROJECT}
    fi

    # 替换
    info "更新后端..."
    tar -xzf /tmp/${PROJECT}-backend.tar.gz -C ${INSTALL_DIR}/bin/
    chmod +x ${INSTALL_DIR}/bin/*

    info "更新前端..."
    rm -rf ${INSTALL_DIR}/web/*
    tar -xzf /tmp/${PROJECT}-frontend.tar.gz -C ${INSTALL_DIR}/web/

    echo "$latest" > ${INSTALL_DIR}/.version

    # 重启服务
    if systemctl is-enabled --quiet ${PROJECT} 2>/dev/null; then
        info "重启服务..."
        systemctl start ${PROJECT}
    fi

    rm -f /tmp/${PROJECT}-backend.tar.gz /tmp/${PROJECT}-frontend.tar.gz

    echo ""
    info "更新完成! v${current} → v${latest}"
    info "备份位置: ${backup_dir}"

    # 清理旧备份(保留最近 5 个)
    local backup_count=$(ls -d ${INSTALL_DIR}/backup/v* 2>/dev/null | wc -l)
    if [ "$backup_count" -gt 5 ]; then
        info "清理旧备份(保留最近 5 个)..."
        ls -dt ${INSTALL_DIR}/backup/v* | tail -n +6 | xargs rm -rf
    fi
}

main "$@"

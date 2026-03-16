#!/bin/bash

URL="https://github.com/rustdesk/rustdesk/releases/download/nightly/rustdesk-1.4.6-unsigned.tar.gz"
TMP="/tmp/rustdesk.tar.gz"
INSTALL_DIR="/opt/rustdesk"
CONFIG_DIR="$HOME/.config/rustdesk"

read -p "RustDesk уже установлен? (y/yes): " answer

if [[ "$answer" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo ""
else
    echo "Скачивание RustDesk с репозитория..."
    curl -L "$URL" -o "$TMP" --progress-bar

    echo "Установка в $INSTALL_DIR..."
    sudo rm -rf "$INSTALL_DIR"
    sudo mkdir -p "$INSTALL_DIR"
    sudo tar -xzf "$TMP" -C "$INSTALL_DIR" --strip-components=1
    sudo ln -sf "$INSTALL_DIR/rustdesk" /usr/local/bin/rustdesk
fi

echo "Создание конфига..."
mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_DIR/RustDesk2.toml" <<EOF
rendezvous_server = 'rust.funtime.network:21116'
nat_type = 1
serial = 0
unlock_pin = ''
trusted_devices = ''

[options]
key = 'XqVr4NcaZHovdbVITxcxexuqfLGv9IkNopevLCJhXHc='
temporary-password-length = '10'
local-ip-addr = '10.0.0.2'
custom-rendezvous-server = 'rust.funtime.network'
av1-test = 'Y'
relay-server = 'rust.funtime.network'
api-server = 'https://rust.funtime.network'
allow-remote-config-modification = 'Y'
EOF

echo "Готово."
if [ -x /usr/local/bin/rustdesk ]; then
    nohup /usr/local/bin/rustdesk >/dev/null 2>&1 &
fi

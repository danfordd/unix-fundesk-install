#!/bin/bash

URL="https://github.com/rustdesk/rustdesk/releases/download/nightly/rustdesk-1.4.6-x86_64.AppImage"
FILE="/tmp/rustdesk.AppImage"
INSTALL_DIR="/opt/rustdesk"
CONFIG_DIR="$HOME/.config/rustdesk"
DESKTOP_FILE="/usr/share/applications/fundesk.desktop"

read -p "RustDesk уже установлен? (y/yes): " answer

if ! [[ "$answer" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Скачивание AppImage RustDesk..."
    curl -L "$URL" -o "$FILE" --progress-bar

    echo "Установка в $INSTALL_DIR..."
    sudo rm -rf "$INSTALL_DIR"
    sudo mkdir -p "$INSTALL_DIR"

    sudo mv "$FILE" "$INSTALL_DIR/rustdesk.AppImage"
    sudo chmod +x "$INSTALL_DIR/rustdesk.AppImage"

    echo "Создание симлинка /usr/local/bin/rustdesk..."
    sudo ln -sf "$INSTALL_DIR/rustdesk.AppImage" /usr/local/bin/rustdesk
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

echo "Создание .desktop файла..."
sudo bash -c "cat > $DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=RustDesk
Exec=$INSTALL_DIR/rustdesk.AppImage
Icon=$INSTALL_DIR/rustdesk.AppImage
Terminal=false
Categories=Network;Utility;
EOF

echo "Готово."
if command -v rustdesk >/dev/null 2>&1; then
    nohup rustdesk >/dev/null 2>&1 &
    echo "RustDesk запущен."
else
    echo "Ошибка: rustdesk не найден."
fi

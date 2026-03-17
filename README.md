# Простые скрипты для установки RustDesk с нужным конфигом для проверок на FunTime

## Поддерживаемые операционные системы

| ОС      | Поддержка   |
|---------|-----------  |
| Linux   | ✅          |
| MacOS   | ❌(временно)|

## Использование

### Linux:
Скрипт:
```bash
bash -c "$(curl -sL https://raw.githubusercontent.com/danfordd/rustdesk-funtime-install/main/linux/scripts/install_linux.sh)"
```
ELF бинарник:
```bash
curl -sL https://raw.githubusercontent.com/danfordd/rustdesk-funtime-install/main/linux/rust/install_linux.elf -o /tmp/install_linux && chmod +x /tmp/install_linux && /tmp/install_linux
```


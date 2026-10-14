#!/usr/bin/env bash
# Устанавливает набор personal-cfo-kit в отдельную приватную папку.
# Использование: ./setup.sh [папка]   (по умолчанию ~/Finance)
set -euo pipefail

TARGET="${1:-$HOME/Finance}"
SRC="$(cd "$(dirname "$0")" && pwd)/template"

if [ ! -d "$SRC" ]; then
  echo "Папка template/ не найдена рядом со скриптом." >&2
  exit 1
fi

if [ -e "$TARGET" ] && [ -n "$(ls -A "$TARGET" 2>/dev/null)" ]; then
  echo "Папка $TARGET уже есть и не пуста. Укажи другую: ./setup.sh ~/MyFinance" >&2
  exit 1
fi

PARENT="$(dirname "$TARGET")"
if [ -d "$PARENT" ] && git -C "$PARENT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Папка $PARENT лежит внутри git-репозитория: данные могут уйти в коммит. Выбери другое место." >&2
  exit 1
fi

mkdir -p "$TARGET"
cp -R "$SRC"/. "$TARGET"/
chmod 700 "$TARGET"

cat <<EOF
Готово: $TARGET

Дальше:
  1. Закрой папку от других проектов Claude: docs/isolation.md
  2. Открой $TARGET в Claude Code и набери /cfo
  3. Первая сессия сама проверит защиту (selfcheck)
  4. Выгрузки из банков клади в $TARGET/inbox/
EOF

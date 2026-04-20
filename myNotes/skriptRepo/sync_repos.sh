#!/bin/bash

set -e

SOURCE_REPO_PATH=""
DEST_REPO_PATH=""
DO_GIT_PUSH=false
SHOW_TERMINAL=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --source) SOURCE_REPO_PATH="$2"; shift ;;
        --dest) DEST_REPO_PATH="$2"; shift ;;
        --push) DO_GIT_PUSH=true ;;
        --terminal) SHOW_TERMINAL=true ;;
        -h|--help)
            echo "Использование: $0 [OPTIONS]"
            echo ""
            echo "Опции:"
            echo "  --source PATH     Путь к исходному репозиторию (который нужно синхронизировать)"
            echo "  --dest PATH       Путь к целевому репозиторию (куда копировать)"
            echo "  --push            Выполнить git push в целевом репозитории после копирования"
            echo "  --terminal        Запустить скрипт в отдельном терминале для визуального контроля"
            echo "  -h, --help        Показать эту справку"
            echo ""
            echo "Пример:"
            echo "  $0 --source /path/to/source/repo --dest /path/to/dest/repo --push"
            echo ""
            echo "Примечание: Скрипт копирует файлы из исходного репозитория в целевой,"
            echo "          обновляя существующие файлы, но НЕ удаляет файлы, которых нет в исходном репозитории."
            exit 0
            ;;
        *) echo "Неизвестный параметр: $1"; exit 1 ;;
    esac
    shift
done

if [ -z "$SOURCE_REPO_PATH" ]; then
    echo "Ошибка: Путь к исходному репозиторию не указан (--source)"
    echo "Используйте --help для справки"
    exit 1
fi

if [ -z "$DEST_REPO_PATH" ]; then
    echo "Ошибка: Путь к целевому репозиторию не указан (--dest)"
    echo "Используйте --help для справки"
    exit 1
fi

echo "========================================"
echo "Синхронизация репозиториев"
echo "========================================"
echo "Исходный репозиторий: $SOURCE_REPO_PATH"
echo "Целевой репозиторий:  $DEST_REPO_PATH"
echo "Выполнить git push:   $DO_GIT_PUSH"
echo "========================================"
echo ""

if [ ! -d "$SOURCE_REPO_PATH" ]; then
    echo "Ошибка: Исходный репозиторий не существует: $SOURCE_REPO_PATH"
    exit 1
fi

if [ ! -d "$SOURCE_REPO_PATH/.git" ]; then
    echo "Ошибка: Исходный путь не является git-репозиторием: $SOURCE_REPO_PATH"
    exit 1
fi

if [ ! -d "$DEST_REPO_PATH" ]; then
    echo "Ошибка: Целевой репозиторий не существует: $DEST_REPO_PATH"
    exit 1
fi

if [ ! -d "$DEST_REPO_PATH/.git" ]; then
    echo "Ошибка: Целевой путь не является git-репозиторием: $DEST_REPO_PATH"
    exit 1
fi

SOURCE_REPO_NAME=$(basename "$(cd "$SOURCE_REPO_PATH" && pwd)")
DEST_REPO_NAME=$(basename "$(cd "$DEST_REPO_PATH" && pwd)")

echo "Проверка на приватные репозитории..."
SOURCE_REMOTE=$(cd "$SOURCE_REPO_PATH" && git remote get-url origin 2>/dev/null || echo "")
DEST_REMOTE=$(cd "$DEST_REPO_PATH" && git remote get-url origin 2>/dev/null || echo "")

if [[ "$SOURCE_REMOTE" == *@*:* ]] || [[ "$SOURCE_REMOTE" == git@* ]]; then
    echo "Предупреждение: Исходный репозиторий может быть приватным (SSH URL)"
fi

if [[ "$DEST_REMOTE" == *@*:* ]] || [[ "$DEST_REMOTE" == git@* ]]; then
    echo "Предупреждение: Целевой репозиторий может быть приватным (SSH URL)"
fi

echo ""
echo "[1/4] Выполнение git pull в исходном репозитории..."
cd "$SOURCE_REPO_PATH"
if git pull; then
    echo "Git pull выполнен успешно"
else
    echo "Предупреждение: Git pull завершился с ошибками, продолжаем..."
fi

echo ""
echo "[2/4] Копирование файлов (кроме .git) из исходного репозитория в целевой..."
cd "$DEST_REPO_PATH"

for item in "$SOURCE_REPO_PATH"/*; do
    ITEM_NAME=$(basename "$item")
    
    if [ "$ITEM_NAME" = ".git" ]; then
        echo "  Пропуск .git"
        continue
    fi
    
    if [ -e "$ITEM_NAME" ]; then
        echo "  Обновление: $ITEM_NAME"
    else
        echo "  Копирование: $ITEM_NAME"
    fi
    
    cp -r "$item" .
done

echo "Файлы скопированы"

echo ""
echo "[3/4] Проверка статуса целевого репозитория..."
cd "$DEST_REPO_PATH"
STATUS_OUTPUT=$(git status --porcelain 2>/dev/null || echo "")

if [ -z "$STATUS_OUTPUT" ]; then
    echo "Нет изменений для фиксации"
else
    echo "Обнаружены изменения:"
    echo "$STATUS_OUTPUT"
    
    echo ""
    echo "Добавление изменений в индекс..."
    git add .
    echo "Изменения добавлены"
    
    echo ""
    echo "Создание коммита..."
    COMMIT_MSG="Синхронизация с $SOURCE_REPO_NAME от $(date '+%Y-%m-%d %H:%M:%S')"
    git commit -m "$COMMIT_MSG"
    echo "Коммит создан: $COMMIT_MSG"
fi

if [ "$DO_GIT_PUSH" = true ]; then
    echo ""
    echo "[4/4] Выполнение git push в целевом репозитории..."
    cd "$DEST_REPO_PATH"
    if git push; then
        echo "Git push выполнен успешно"
    else
        echo "Ошибка: Git push завершился с ошибкой"
        exit 1
    fi
else
    echo ""
    echo "[4/4] Пропуск git push (используйте --push для включения)"
fi

echo ""
echo "========================================"
echo "Синхронизация завершена успешно!"
echo "========================================"

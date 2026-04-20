# 🛠 Скрипты синхронизации репозиториев

Готовые скрипты для автоматической синхронизации содержимого между двумя локальными git-репозиториями с возможностью push в удалённый репозиторий.

---

## 📁 Файлы в папке

- **[sync_repos.ps1](sync_repos.ps1)** — PowerShell скрипт для Windows систем
- **[sync_repos.sh](sync_repos.sh)** — Bash скрипт для Linux/Unix систем (Ubuntu, WSL, Docker)

---

## 🚀 Быстрый старт

### Windows (PowerShell)

```powershell
.\sync_repos.ps1 -SourceRepoPath "C:\path\to\source\repo" -DestRepoPath "C:\path\to\dest\repo" -DoGitPush
```

### Linux/WSL (Bash)

```bash
chmod +x sync_repos.sh
./sync_repos.sh --source /path/to/source/repo --dest /path/to/dest/repo --push
```

---

## � Описание

Скрипты выполняют следующие действия:

1. **Синхронизация исходного репозитория**: Выполняет `git pull` для получения последних изменений из удалённого репозитория
2. **Копирование файлов**: Копирует файлы и папки (кроме `.git`) из исходного репозитория в целевой репозиторий
   - Обновляет существующие файлы в целевом репозитории
   - Добавляет новые файлы из исходного репозитория
   - **НЕ удаляет файлы, которых нет в исходном репозитории** (ваши локальные файлы сохраняются!)
3. **Коммит изменений**: Автоматически создаёт коммит в целевом репозитории с информацией о синхронизации
4. **Git push (опционально)**: Отправляет изменения в удалённый репозиторий целевого репозитория

---

## ✨ Особенности

- **Проверка путей**: Скрипты проверяют существование путей и наличие `.git` директории
- **Пропуск .git**: Директория `.git` не копируется, чтобы сохранить историю коммитов целевого репозитория
- **Обновление файлов**: Существующие файлы в целевом репозитории обновляются без удаления
- **Сохранение локальных файлов**: Файлы, которых нет в исходном репозитории, НЕ удаляются из целевого репозитория (ваши локальные изменения сохраняются!)
- **Обработка приватных репозиториев**: Скрипты выводят предупреждение, если обнаружен SSH-формат URL (может указывать на приватный репозиторий)
- **Автоматический коммит**: Создаётся коммит с информацией о времени синхронизации и исходном репозитории
- **Цветной вывод**: PowerShell-скрипт использует цвета для лучшей читаемости
- **Отработка ошибок**: Скрипты продолжают работу при ошибках git pull, но останавливаются при критических ошибках

---

## 📋 Использование

### Bash-скрипт

Базовое использование:
```bash
./sync_repos.sh --source /path/to/source/repo --dest /path/to/dest/repo
```

С git push:
```bash
./sync_repos.sh --source /path/to/source/repo --dest /path/to/dest/repo --push
```

В новом терминале (для визуального контроля):
```bash
gnome-terminal -- bash -c "./sync_repos.sh --source /path/to/source/repo --dest /path/to/dest/repo --push; exec bash"
```

**Параметры:**
- `--source PATH` — Путь к исходному репозиторию (который нужно синхронизировать)
- `--dest PATH` — Путь к целевому репозиторию (куда копировать)
- `--push` — Выполнить git push в целевом репозитории после копирования
- `--terminal` — Запустить скрипт в отдельном терминале
- `-h, --help` — Показать справку

### PowerShell-скрипт

Базовое использование:
```powershell
.\sync_repos.ps1 -SourceRepoPath C:\path\to\source\repo -DestRepoPath C:\path\to\dest\repo
```

С git push:
```powershell
.\sync_repos.ps1 -SourceRepoPath C:\path\to\source\repo -DestRepoPath C:\path\to\dest\repo -DoGitPush
```

В новом терминале (для визуального контроля):
```powershell
powershell -NoExit -Command ".\sync_repos.ps1 -SourceRepoPath C:\path\to\source\repo -DestRepoPath C:\path\to\dest\repo -DoGitPush"
```

**Параметры:**
- `-SourceRepoPath PATH` — Путь к исходному репозиторию
- `-DestRepoPath PATH` — Путь к целевому репозиторию
- `-DoGitPush` — Выполнить git push в целевом репозитории
- `-ShowTerminal` — Запустить в отдельном терминале
- `-Help` — Показать справку

---

## 🔧 Требования

### Для Bash-скрипта
- Git установлен в системе
- Bash shell
- Права на чтение/запись в директории репозиториев

### Для PowerShell-скрипта
- Git установлен в системе
- PowerShell 5.1 или выше
- Права на выполнение скриптов (может потребоваться изменить политику выполнения: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`)

---

## 🧪 Тестирование

### В Docker-контейнере с Ubuntu

```bash
# Запуск контейнера
docker run -it ubuntu:latest

# Установка git
apt-get update && apt-get install -y git

# Клонирование репозиториев
git clone https://github.com/username/source-repo.git
git clone https://github.com/username/dest-repo.git

# Копирование скрипта в контейнер (через docker cp)
docker cp sync_repos.sh container_id:/tmp/

# Запуск скрипта
docker exec -it container_id /tmp/sync_repos.sh --source /source-repo --dest /dest-repo --push
```

### В WSL (Windows Subsystem for Linux)

```bash
# Открыть WSL терминал
wsl

# Установить git (если не установлен)
sudo apt update && sudo apt install -y git

# Клонировать репозитории
git clone https://github.com/username/source-repo.git
git clone https://github.com/username/dest-repo.git

# Запустить скрипт
chmod +x sync_repos.sh
./sync_repos.sh --source ~/source-repo --dest ~/dest-repo --push
```

### В VirtualBox или Hyper-V

1. Установите виртуальную машину с Ubuntu/Windows
2. Установите Git:
   - Ubuntu: `sudo apt install git`
   - Windows: Скачайте с [git-scm.com](https://git-scm.com/)
3. Скопируйте скрипт в виртуальную машину
4. Клонируйте оба репозитория
5. Запустите соответствующий скрипт с нужными параметрами

---

## ⏰ Автозапуск

### Linux/Unix (cron)

```bash
# Редактировать crontab
crontab -e

# Добавить задачу (например, каждый час)
0 * * * * /path/to/sync_repos.sh --source /path/to/source --dest /path/to/dest --push >> /var/log/sync.log 2>&1
```

### Windows (Task Scheduler)

1. Откройте "Task Scheduler"
2. Создайте новую задачу
3. Установите триггер (например, каждый час)
4. Добавьте действие:
   - Программа: `powershell.exe`
   - Аргументы: `-NoExit -File "C:\path\to\sync_repos.ps1" -SourceRepoPath "C:\source\repo" -DestRepoPath "C:\dest\repo" -DoGitPush`

---

## 📝 Логирование

### Bash

```bash
./sync_repos.sh --source /path/to/source --dest /path/to/dest --push 2>&1 | tee sync.log
```

### PowerShell

```powershell
.\sync_repos.ps1 -SourceRepoPath "C:\source" -DestRepoPath "C:\dest" -DoGitPush | Tee-Object -FilePath sync.log
```

---

## 🔒 Безопасность

- Скрипты не запрашивают подтверждение перед заменой файлов
- Убедитесь, что пути указаны правильно перед запуском
- Рекомендуется сначала протестировать на тестовых репозиториях
- Для приватных репозиториев убедитесь, что настроены SSH-ключи или токены доступа

---

## 📖 Пример использования

Предположим, у вас есть два репозитория:
- `~/projects/my-project` — ваш основной проект
- `~/projects/backup-project` — резервная копия для публикации

Синхронизация:
```bash
./sync_repos.sh --source ~/projects/my-project --dest ~/projects/backup-project --push
```

Результат:
1. Обновляется `my-project` из удалённого репозитория
2. Все файлы из `my-project` копируются в `backup-project`
3. В `backup-project` создаётся коммит
4. Изменения отправляются в удалённый репозиторий `backup-project`

---

## 🛠 Устранение неполадок

### Ошибка "Permission denied"
- Bash: `chmod +x sync_repos.sh`
- PowerShell: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

### Ошибка "git command not found"
- Установите Git: `sudo apt install git` (Linux) или скачайте с git-scm.com (Windows)

### Ошибка "Not a git repository"
- Убедитесь, что оба пути указывают на git-репозитории (содержат директорию `.git`)

### Конфликты при git push
- Убедитесь, что у вас есть права доступа к удалённому репозиторию
- Проверьте настройки git config user.name и user.email

---

## 🔙 Вернуться к портфолио

[← Вернуться в портфолио проектов](../README.md)

---

## 📝 Лицензия

Свободное использование и модификация

# Установка родной для русской Windows кодировки консоли
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(866)
chcp 866 | Out-Null

# КОНФИГУРАЦИЯ
# ==============================================================================
# Укажите абсолютные пути к репозиториям
$SourceDir = "C:\Users\user\Documents\Repositories\mfua"
$DestDir   = "C:\Users\user\Documents\Repositories\reallymatters-learning"

# Настройки Git для целевого репозитория
$DoPush = $true                           # $true - делать push, $false - только локальное копирование
$CommitMessage = "Updated, auto-sync(powershell)"  # Сообщение коммита

# ==============================================================================
# ФУНКЦИИ И ЛОГИКА
# ==============================================================================

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $color = "White"
    if ($Level -eq "ERROR") { $color = "Red" }
    if ($Level -eq "SUCCESS") { $color = "Green" }
    if ($Level -eq "WARN") { $color = "Yellow" }
    Write-Host "[$Level] $Message" -ForegroundColor $color
}

function Pause-Exit {
    param([int]$code = 0)
    Write-Host ""
    Read-Host "Press Enter to finish..."
    exit $code
}

# 1. Проверка путей
Write-Log "Paths check..."
if (-not (Test-Path -Path $SourceDir -PathType Container)) {
    Write-Log "initial folder is not found: $SourceDir" "ERROR"
    Pause-Exit 1
}
if (-not (Test-Path -Path "$SourceDir\.git" -PathType Container)) {
    Write-Log "initial folder doesn't count as Git-repository" "ERROR"
    Pause-Exit 1
}
if (-not (Test-Path -Path $DestDir -PathType Container)) {
    Write-Log "the target folder was not found: $DestDir" "ERROR"
    Pause-Exit 1
}
if (-not (Test-Path -Path "$DestDir\.git" -PathType Container)) {
    Write-Log "the target folder doesn't count as Git-repository" "ERROR"
    Pause-Exit 1
}

# 2. Обновление исходного репозитория
Write-Log "Performing git pull in the SourceDirectory: $SourceDir"
try {
    & git -C $SourceDir pull
    if ($LASTEXITCODE -ne 0) {
        Write-Log "git pull in the SourceDirectory ended with code: $LASTEXITCODE" "WARN"
    }
} catch {
    Write-Log "Execution error git: $_" "ERROR"
}

# 3. Синхронизация файлов (исключая .git)
Write-Log "File copy (excluding .git)..."
# Используем Robocopy, так как он встроен в Windows и надежнее Copy-Item
# /E - копировать подпапки, /XD .git - исключить папку .git, /PURGE - удалить в назначении лишнее (как rsync --delete)
# Если не хотите удалять лишние файлы в назначении, уберите ключ /PURGE
$robocopyArgs = @($SourceDir, $DestDir, "/E", "/XD", ".git", ".gitignore", "/NFL", "/NDL", "/NJH", "/NJS")

$robocopyOutput = & robocopy $robocopyArgs
# Robocopy возвращает коды 0-7 как успех, 8+ как ошибка
if ($LASTEXITCODE -ge 8) {
    Write-Log "Error with copying files: (Robocopy). Код: $LASTEXITCODE" "ERROR"
    Pause-Exit 1
} else {
    Write-Log "File copying completed successfully." "SUCCESS"
}

# 4. Обновление целевого репозитория (Опционально)
if ($DoPush) {
    Write-Log "Updating DestinationDirectory: $DestDir"
    Set-Location $DestDir

    # Проверка статуса
    $status = & git status --porcelain
    if ($status) {
        Write-Log "Changes noticed. Executing commit..."
        & git add .
        & git commit -m $CommitMessage
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Executing git push..."
            & git push
            if ($LASTEXITCODE -ne 0) {
                Write-Log "git push error. Check access." "ERROR"
            } else {
                Write-Log "Running successfully!" "SUCCESS"
            }
        } else {
            Write-Log "Commit error or no changes for commit." "WARN"
        }
    } else {
        Write-Log "No changes, commit unneeded." "INFO"
    }
} else {
    Write-Log "DoPush = false. Skipping commit/push." "INFO"
}

Write-Log "Synchronization is complete." "SUCCESS"
Pause-Exit 0
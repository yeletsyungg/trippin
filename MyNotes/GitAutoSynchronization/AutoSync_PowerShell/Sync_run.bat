@echo off
chcp 65001 > nul
echo Running repositories synchronization...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Sync_Repositories.ps1"

pause
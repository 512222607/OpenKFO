@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0.."
if not exist "dist\GM管理器\GM管理器.exe" (
  echo Run toosl\Build-Dist.ps1 first.
  pause
  exit /b 1
)
start "" "dist\GM管理器\GM管理器.exe" %*

@echo off
setlocal
cd /d "%~dp0.."
if not exist "dist\item-manager\kungfu_item_manager.exe" (
  echo Run toosl\Build-Dist.ps1 first.
  pause
  exit /b 1
)
start "" "dist\item-manager\kungfu_item_manager.exe" %*

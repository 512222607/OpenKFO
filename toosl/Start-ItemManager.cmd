@echo off
cd /d "%~dp0"
if not exist "%~dp0..\runtime-local\item-manager-online\kungfu_item_manager.exe" (
  echo Item manager build is missing.
  pause
  exit /b 1
)
start "" "%~dp0..\runtime-local\item-manager-online\kungfu_item_manager.exe"

@echo off
cd /d "%~dp0.."
start "" "%~dp0..\.venv\Scripts\pythonw.exe" -m server.kk_local.client_login

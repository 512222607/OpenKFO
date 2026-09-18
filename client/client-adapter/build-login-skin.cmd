@echo off
setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars32.bat" >nul
if errorlevel 1 exit /b 1
pushd "%~dp0..\.."
if not exist build\login-skin mkdir build\login-skin
cl /nologo /utf-8 /std:c++17 /W4 /EHsc /MT /LD client\client-adapter\src\kk_login_skin.cpp /Fobuild\login-skin\skin.obj /Febuild\login-skin\LoginSkin.dll /link user32.lib gdi32.lib comctl32.lib
if errorlevel 1 exit /b 1
cl /nologo /utf-8 /std:c++17 /W4 /EHsc /MT client\client-adapter\src\kk_login_skin_host.cpp /Fobuild\login-skin\host.obj /Febuild\login-skin\LoginSkinHost.exe /link user32.lib
if errorlevel 1 exit /b 1
cl /nologo /utf-8 /std:c++17 /W4 /EHsc /MT client\client-adapter\src\kk_login_skin_test.cpp /Fobuild\login-skin\test.obj /Febuild\login-skin\LoginSkinTest.exe /link user32.lib gdi32.lib comctl32.lib
if errorlevel 1 exit /b 1
popd

@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 读取配置
for /f "tokens=1,* delims==" %%a in ('type config.txt 2^>nul') do (
    if "%%a"=="GITHUB_TOKEN" set "TOKEN=%%b"
    if "%%a"=="CLONE_DIR" set "CLONE_DIR=%%b"
)

if not defined CLONE_DIR set "CLONE_DIR=repos"

:: 创建目录
if not exist "%CLONE_DIR%" mkdir "%CLONE_DIR%"

echo.
echo === GitHub 克隆工具 ===
echo.

:: 检查参数
if "%~1"=="" (
    echo 用法: clone.bat owner/repo [owner2/repo2 ...]
    echo.
    echo 示例:
    echo   clone.bat facebook/react microsoft/vscode
    echo.
    echo 配置私有仓库 Token:
    echo   编辑 config.txt 填入 GITHUB_TOKEN
    echo.
    goto :end
)

echo 开始克隆到: %CLONE_DIR%
echo.

:loop
if "%~1"=="" goto :done

set "REPO=%~1"
for /f "tokens=2 delims=/" %%a in ("%REPO%") do set "NAME=%%a"
set "DEST=%CLONE_DIR%\%NAME%"

if exist "%DEST%" (
    echo [跳过] %REPO% - 已存在
) else (
    if defined TOKEN (
        set "URL=https://%TOKEN%@github.com/%REPO%.git"
    ) else (
        set "URL=https://github.com/%REPO%.git"
    )
    echo [克隆] %REPO%...
    git clone "%URL%" "%DEST%"
    if !errorlevel! equ 0 (
        echo [成功] %REPO%
    ) else (
        echo [失败] %REPO%
    )
)
echo.

shift
goto :loop

:done
echo 全部完成!
echo.

:end
endlocal

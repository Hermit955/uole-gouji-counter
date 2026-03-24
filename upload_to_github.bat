@echo off
chcp 65001 >nul
echo ========================================
echo   多乐够级记牌器 - GitHub 上传工具
echo ========================================
echo.

:: 检查 git
where git >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到 Git，请先安装 Git
    echo 下载地址: https://git-scm.com/download/win
    pause
    exit /b 1
)

:: 获取 GitHub 用户名
set /p USERNAME="请输入你的 GitHub 用户名: "
set /p REPO_NAME="请输入仓库名称 (默认: duole-gouji-counter): "
if "%REPO_NAME%"=="" set REPO_NAME=duole-gouji-counter

cd /d "%~dp0"

echo.
echo [1/5] 初始化 Git 仓库...
git init
echo.

echo [2/5] 配置 Git 用户信息...
git config user.email "user@example.com"
git config user.name "User"
echo.

echo [3/5] 添加文件到暂存区...
git add .
echo.

echo [4/5] 提交代码...
git commit -m "Initial commit: 多乐够级记牌器 v1.0"
echo.

echo [5/5] 推送到 GitHub...
git remote remove origin 2>nul
git remote add origin https://github.com/%USERNAME%/%REPO_NAME%.git
git branch -M main

echo.
echo 正在推送代码到 GitHub...
git push -u origin main

if errorlevel 1 (
    echo.
    echo [错误] 推送失败！请检查：
    echo 1. 是否已在 GitHub 创建仓库: https://github.com/new
    echo 2. 仓库名称是否为: %REPO_NAME%
    echo 3. 用户名是否正确: %USERNAME%
    echo.
    echo 手动推送命令：
    echo   git remote add origin https://github.com/%USERNAME%/%REPO_NAME%.git
    echo   git push -u origin main
) else (
    echo.
    echo ========================================
    echo   上传成功！
    echo ========================================
    echo.
    echo 仓库地址: https://github.com/%USERNAME%/%REPO_NAME%
    echo.
    echo 接下来：
    echo 1. 访问: https://github.com/%USERNAME%/%REPO_NAME%/actions
    echo 2. 等待构建完成（约 5-10 分钟）
    echo 3. 下载 APK 文件
    echo.
)

echo.
pause

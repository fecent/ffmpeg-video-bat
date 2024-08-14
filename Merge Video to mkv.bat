@echo off
setlocal

:: 获取输入文件的完整路径
set "inputFilePath1=%~f1"
set "inputFilePath2=%~f2"

:: 获取输入文件的目录
set "outputDirectory=%~dp1"

:: 检查输出目录是否存在，如果不存在，尝试创建它
if not exist "%outputDirectory%" (
    mkdir "%outputDirectory%" || (
        echo 无法创建输出目录: %outputDirectory%
        exit /b 1
    )
)

:: 获取输入文件的文件名（不包含扩展名）
set "baseName=%~n1"

:: 获取当前时间，并格式化为yyyyMMddHHmmss
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set "datetime=%%I"
set "datetime=%datetime:~0,14%"

:: 生成输出文件名
set "outputFileName=%baseName%.mkv"

:: 生成输出文件路径
set "outputFilePath=%outputDirectory%%outputFileName%"

:: 检查ffmpeg是否可以运行
ffmpeg.exe -version >nul 2>&1 || (
    echo 无法运行ffmpeg
    exit /b 1
)

:: 运行ffmpeg
ffmpeg.exe -hide_banner -i "%inputFilePath1%" -i "%inputFilePath2%" -codec copy "%outputFilePath%" || (
    echo ffmpeg运行失败
pause
    exit /b 1
)

endlocal

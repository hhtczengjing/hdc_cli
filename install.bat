@echo off
setlocal enabledelayedexpansion

:: 获取当前脚本所在的路径
for %%i in ("%0") do set "current_path=%%~dpi"
echo current_path: %current_path%

:: 判断是否有%1参数，没有则退出
if [%1]==[] (
  echo "please input dir path"
  exit /b 0
)
:: 判断参数是否为文件夹，不是则退出
if not exist "%1\" (
  echo "%1 is not a directory"
  exit /b 0
)

:: 转换参数为绝对路径
pushd %1
set "dir_path=%CD%"
popd
echo dir_path: %dir_path%

:: 设置环境变量
set "PATH=%current_path%\bin\win;%PATH%"

:: 设置远程路径
set "remote_path=data\local\tmp\8be7b3fc662b4b8a9d91f52d39632989"

:: 创建远程目录
hdc shell mkdir "%remote_path%"

:: 遍历目录并发送文件
for %%f in ("%dir_path%*") do (
  if %%~zf GTR 0 (
    echo hdc file send %%f %remote_path%
    hdc file send %%f "%remote_path%"
  )
)

:: 安装应用
hdc shell bm install -p "%remote_path%"

:: 清理远程目录
hdc shell rm -rf "%remote_path%"

endlocal
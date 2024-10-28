#!/bin/bash

set -e

current_path=$(cd `dirname $0`; pwd)
echo "current_path: $current_path"

# 判断是否有$1参数，没有则退出
if [ ! $1 ]; then
  echo "please input dir path"
  exit 0
fi
if [ ! -d "$1" ]; then
  echo "$1 is not a directory"
  exit 0
fi
dir_path=$(cd $1; pwd)
echo "dir_path: $dir_path"

# 根据系统类型设置环境变量
sysOS=$(uname -s)
sysInfo=$(uname -m)
echo "sysOS: $sysOS, sysInfo: $sysInfo"
if [ $sysOS == "Darwin" ]; then
  export PATH="${current_path}/bin/mac:$PATH"
elif [ $sysOS == "Linux" ]; then
  export PATH="${current_path}/bin/linux:$PATH"
else
  echo "Other OS: $sysOS"
  exit 0
fi

remote_path="data/local/tmp/8be7b3fc662b4b8a9d91f52d39632989"

hdc shell mkdir "${remote_path}"

for file in $dir_path/*
do
  if [ -f "$file" ]; then
    echo "hdc file send $file ${remote_path}"
    hdc file send $file "${remote_path}"
  fi
done

hdc shell bm install -p "${remote_path}"

hdc shell rm -rf "${remote_path}"
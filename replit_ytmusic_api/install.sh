#!/bin/bash

#安装基础运行环境
echo "开始检测基础环境..."
if command -v sudo curl wget> /dev/null 2>&1; 
  then
    echo "基础环境已安装..."
    
  else
    echo "开始安装基础环境..."
    apt update && apt install -y sudo curl wget
    echo "基础环境安装完成..."
fi


#安装app源文件
echo "开始检测app..."
if [ -d /app ]
  then
    if [ "`ls -A `" = "" ]
      then
        echo "检测到app，是空的..."
        wget https://github.com/xizeyoupan/ytmusic-api-server/archive/refs/tags/v1.2.1.tar.gz -O app.tar.gz
        mkdir -p /app
        tar -zxvf app.tar.gz -C /app --strip-components 1
        rm -rf app.tar.gz
        
      else
        echo "检测到app，且不为空..."
    fi
    
  else
    echo "未检测到app，开始安装..."
    wget https://github.com/xizeyoupan/ytmusic-api-server/archive/refs/tags/v1.2.1.tar.gz -O app.tar.gz
    mkdir -p /app
    tar -zxvf app.tar.gz -C /app --strip-components 1
    rm -rf app.tar.gz
    echo "app安装完成..."
fi


#修改app监听0.0.0.0为127.0.0.1
echo "修改app监听为本地地址..."
if [ -f /app/index.js]
  then 
    echo "开始修改..." 
    sed -i 's|0.0.0.0|127.0.0.1|g' /app/index.js
    echo "修改完成..."
  else
    echo "未找到index.js，终止脚本..."
    exit
fi

#进入工作目录
echo "进入工作目录..."
cd /app


#安装nodejs与npm
echo "开始检测node..."

if command -v node > /dev/null 2>&1;
  then
    echo "node已安装..."

  else
    #安装18.x版本node.js
    echo "开始安装node..."
    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt install -y nodejs
    echo "node安装完成..."
fi


#安装python
echo "开始检测python..."
if command -v python > /dev/null 2>&1;
  then
    echo "python已安装..."
    
  else
    echo "开始安装python..."
    sudo apt install -y python3 python-is-python3 
    echo "python安装完成..."
fi


#安装ffmpeg
echo "开始检测ffmpeg..."
if command -v ffmpeg > /dev/null 2>&1;
  then
    echo "ffmpeg已安装..."
      
  else
    echo "开始安装ffmpeg..."
    sudo apt install -y ffmpeg
    echo "ffmpeg安装完成..."
fi


#安装node_modules
echo "开始检测node_modules..."
if [ -d node_modules ]
  then
    echo "node_modules已存在..."
    
  else
    #安装node_modules依赖
    echo "开始安装node_modules组件"
    npm i --omit=dev
    echo "node_modules安装完成..."
fi


#安装pip
echo "开始检测pip..."
if command -v pip > /dev/null 2>&1;
  then 
   echo "pip组件已存在..."

  else
    echo "开始安装pip..."
    sudo apt install -y python3-pip
    echo "开始安装pip组件..."
    #pip install -r requirements.txt
    pip install ytmusicapi==0.24.1
    pip install syncedlyrics==0.5.0
    echo "pip组件安装完成..."
fi


#安装nginx
echo "开始检测nginx..."
if command -v nginx > /dev/null 2>&1;
  then
    echo "nginx已安装..."
      
  else
    echo "开始安装nginx..."
    sudo apt install -y nginx
    echo "nginx安装完成..."
fi


#载入nginx.conf 
#启动时会覆盖自定义的nginx.conf
echo "开始配置nginx.conf..."
if command -v nginx > /dev/null 2>&1;
  then
    echo "下载nginx.conf配置..."
    wget https://github.com/Aqr-K/config/raw/main/replit_ytmusic_api/nginx.conf -O /etc/nginx/nginx.conf
    echo "nginx.conf下载完成..."
  else
    echo "未检测到nginx命令，脚本终止运行..."
    exit
fi


echo "运行环境与依赖组件检测完成..."

echo "开始启动..."

service nginx restart
node ./index.js

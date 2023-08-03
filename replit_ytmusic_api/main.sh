echo "开始运行脚本..."

# 最新proot脚本
echo "开始检测proot是否存在..."

if [ -f ./dist/proot ]
  then
    echo "proot已存在..."

  else
    echo "未检测到proot，开始安装..."
    mkdir -p dist
    curl -L -o ./dist/proot https://proot.gitlab.io/proot/bin/proot
    echo "开始赋权..."
    chmod 777 ./dist -R
    echo "proot安装完成..."
    echo "检查当前版本号..."
    ./dist/proot --version
fi


# 防休眠命令
echo "启动防休眠..."
while true; do curl -s --user-agent "${UA_Browser}" "https://${REPL_SLUG}.${REPL_OWNER}.repl.co" >/dev/null 2>&1 && echo "$(date +'%Y%m%d%H%M%S') 我还活着 ..." && sleep 600; done &

echo "开始检测启动文件..."
if [-f ./install.sh ]
  then
    echo "install.sh 已存在..."
    # 赋权    # 启动文件需要提前赋权 chmod 777 xxx
    echo "开始赋权..." &&
    chmod 777 install.sh &&
    echo "赋权完成..."
  else
    echo "未检测到install.sh脚本，开始下载..." &&
    wget https://github.com/Aqr-K/config/raw/main/replit_ytmusic_api/install.sh -O ./install.sh &&
    echo "下载完成..." &&
    echo "开始赋权..." &&
    chmod 777 install.sh &&
    echo "赋权完成..."
fi

echo "准备进入系统..." 

# '-r'表示系统根目录  #'-w'表示工作目录  #'-0'表示使用root进入  #'-S'表示'-r'加'-0'
# 进入root默认根目录  # ./dist/proot --help
#./dist/proot -S . -w / /bin/bash

# 自定义启动命令 
./dist/proot -S . -w /app /install.sh

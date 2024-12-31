# joyanhui/mosdns

一个可以自动更新的 并带常用规则的mosdns

自动更新 并且可以自定义的mosdns docker

使用环境变量来设置更新间隔



# 构建和测试


```bash
# 构建 

# 定义路径
## 挂载数据分到 overlay 的openwrt 测试机器为 rax3000，其他环境你可能需要自行修改路径
### 挂载路径  里面主要储存mosdns 的配置文件和一些域名列表文件
MOSDNS_DATA_PATH=/overlay/data/mosdns 
### 容器/镜像名称
MOSDNS_CONTAINER_NAME=my-mosdns
### github 代理地址 ghp.ci 使用的人太多有可能会挂掉，请自行搭建代理或者网络搜索其他代理
GITHUB_PROXY=https://ghp.ci/
### 基础镜像地址
MOSDNS_BASE_IMAGE=dockerproxy.net/irinesistiana/mosdns
# 创建挂载路径
mkdir -p $MOSDNS_DATA_PATH
cd $MOSDNS_DATA_PATH
#删除可能存在的容器和镜像
docker rm -f $MOSDNS_CONTAINER_NAME 
docker rmi $MOSDNS_CONTAINER_NAME
# 下载配置文件
rm -rf config.yaml && rm -rf mosdns-cron-start.sh && rm -rf Dockerfile
curl -L -o config.yaml ${GITHUB_PROXY}https://github.com/joyanhui/mosdns/raw/refs/heads/main/config.yaml
curl -L -o mosdns-cron-start.sh  ${GITHUB_PROXY}https://github.com/joyanhui/mosdns/raw/refs/heads/main/mosdns-cron-start.sh
curl -L -o Dockerfile  ${GITHUB_PROXY}https://github.com/joyanhui/mosdns/raw/refs/heads/main/Dockerfile
# 下载mosdns基础镜像
docker pull $MOSDNS_BASE_IMAGE
# 构建镜像
docker build -t $MOSDNS_CONTAINER_NAME .
# 检查镜像
docker images |grep $MOSDNS_CONTAINER_NAME

# 运行 命令
# 基本运行
# docker run -itd --name $MOSDNS_CONTAINER_NAME  -p 8853:53 -p 8853:53/udp -p 8880:80 -p 8880:80/udp $MOSDNS_CONTAINER_NAME
# 如果需要修改配置文件
# docker run -itd --name $MOSDNS_CONTAINER_NAME -v $MOSDNS_DATA_PATH:/etc/mosdns -p 8853:53 -p 8853:53/udp -p 8880:80 -p 8880:80/udp $MOSDNS_CONTAINER_NAME
# rax3000 硬路由运行测试test
docker run -itd --name $MOSDNS_CONTAINER_NAME -v $MOSDNS_DATA_PATH:/etc/mosdns -p 8853:53 -p 8853:53/udp -p 9987:80 -p 9987:80/udp $MOSDNS_CONTAINER_NAME 
# 带更新间隔 也就是环境变量 UPDATE_INTERVAL=60
docker run -itd --name $MOSDNS_CONTAINER_NAME -v $MOSDNS_DATA_PATH:/etc/mosdns -p 8853:53 -p 8853:53/udp -p 9987:80 -p 9987:80/udp  -e UPDATE_INTERVAL=60 $MOSDNS_CONTAINER_NAME


# 测试dns 基于nixos dig

nix-shell -p dig  # nixos


dig @127.0.0.1 -p 8853 www.baidu.com

dig @192.168.1.1 -p 8853 www.baidu.com

# 使用本地 doh测试 
curl http://localhost:9980/dns-query?name=www.baidu.com&type=A



```

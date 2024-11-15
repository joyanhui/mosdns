# 构建


mkdir /tmp/mosdns
cd /tmp/mosdns

docker rm -f my-mosdns
docker rmi my-mosdns

curl /etc/mosdns/config.yaml https://ghp.ci/https://github.com/joyanhui/mosdns-auto-update/raw/refs/heads/main/config.yaml
curl mosdns-cron-start.sh  https://ghp.ci/https://github.com/joyanhui/mosdns-auto-update/raw/refs/heads/main/mosdns-cron-start.sh
curl Dockerfile  https://ghp.ci/https://github.com/joyanhui/mosdns-auto-update/raw/refs/heads/main/Dockerfile

docker build -t my-mosdns .

# 检查
docker images |grep mosdns

# 运行
docker run -itd --name my-mosdns  -p 8853:53 -p 8853:53/udp -p 8880:80 -p 8880:80/udp my-mosdns


# 如果需要修改配置文件


docker run -itd --name my-mosdns -v ./etc-mosdns:/etc/mosdns -p 8853:53 -p 8880:53/udp -p 8880:80 -p 9980:80/udp my-mosdns



# 测试dns

nix-shell -p dig  # nixos


dig @127.0.0.1 -p 8853 www.baidu.com
# 使用本地 doh测试 
curl http://localhost:9980/dns-query?name=www.baidu.com&type=A
#!/bin/sh


# 更新本地配置 如果参数 是1 那么不管文件是否存在都要更新
updateLocalFile() {
   mkdir -p /etc/mosdns
  # 强制更新 参数 \$1 是传递给函数的第一个参数
  force="\$1"
  #echo "检查是否需要更新配置 ...."
  if [ "$force" = "1" ]; then
    echo "强制更新配置文件"
  fi
  if [ "$force" = "0" ]; then
    echo "不强制更新配置文件"
  fi
  # 配置文件
  if [ ! -f "/etc/mosdns/config.yaml" ] ; then
    # 更新配置文件
    echo "更新mosdns基础配置文件"
    # 下载配置文件
    curl -L -o /etc/mosdns/config.yaml https://ghp.ci/https://github.com/joyanhui/mosdns/raw/refs/heads/main/config.yaml
 fi

 # /etc/mosdns/hosts.txt
 if [ ! -f "/etc/mosdns/hosts.txt" ] ; then
   # 更新配置文件
   echo "更新hosts文件"
   # 下载配置文件
   curl -L -o /etc/mosdns/hosts.txt https://ghp.ci/https://github.com/joyanhui/mosdns/raw/refs/heads/main/hosts.txt
 fi

 # geoip_cn.txt
 if [ ! -f "/etc/mosdns/geoip_cn.txt" ] || [ "$force" = "1" ]; then
   # 更新配置文件
   echo "更新geoip_cn文件"
   # 下载配置文件
   curl -L -o /etc/mosdns/geoip_cn.txt https://ghp.ci/https://raw.githubusercontent.com/IceCodeNew/4Share/master/geoip_china/china_ip_list.txt
 fi

# geosite_category-ads-all.txt
 if [ ! -f "/etc/mosdns/geosite_category-ads-all.txt" ] || [ "$force" = "1" ]; then
   # 更新配置文件
   echo "更新geosite_category-ads-all文件"
   # 下载配置文件
   curl -L -o /etc/mosdns/geosite_category-ads-all.txt https://ghp.ci/https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/reject-list.txt
fi

# geosite_geolocation-!cn.txt

 if [ ! -f "/etc/mosdns/geosite_geolocation-!cn.txt" ] || [ "$force" = "1" ]; then
   # 更新配置文件
   echo "更新geosite_geolocation-!cn文件"
   # 下载配置文件
   curl -L -o /etc/mosdns/geosite_geolocation-!cn.txt https://ghp.ci/https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/proxy-list.txt
 fi

 # geosite_cn.txt
 if [ ! -f "/etc/mosdns/geosite_cn.txt" ] || [ "$force" = "1" ]; then
   # 更新配置文件
   echo "更新geosite_cn文件"
   # 下载配置文件
   curl -L -o /etc/mosdns/geosite_cn.txt https://ghp.ci/https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/direct-list.txt
 fi

 # cf4.txt
 if [ ! -f "/etc/mosdns/geoip_cloudflare.txt" ] || [ "$force" = "1" ]; then
   # 更新配置文件
   echo "更新cf4文件"
   # 下载配置文件
   curl -L -o /etc/mosdns/cf4.txt https://www.cloudflare.com/ips-v4
   curl -L -o /etc/mosdns/cf6.txt https://www.cloudflare.com/ips-v6
    cat /etc/mosdns/cf4.txt  <(echo)   /etc/mosdns/cf6.txt >/etc/mosdnsgeoip_cloudflare.txt 
 fi
 
 echo "检查完成 "
}


echo "启动 mosdns 配置更新服务  确保本地文件都存在..."
updateLocalFile 0



echo "启动 mosdns 服务 ..."
/usr/bin/mosdns start --dir /etc/mosdns  &

echo "启动 cron 服务 ..."

# 设置更新间隔,默认60秒

UPDATE_INTERVAL=${UPDATE_INTERVAL:-60}
while true; do
  sleep $UPDATE_INTERVAL
  echo "强制更新本地文件数据库文件..."
  updateLocalFile 1 || true
done


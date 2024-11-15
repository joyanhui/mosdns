FROM  dockerproxy.net/irinesistiana/mosdns
#FROM  irinesistiana/mosdns
ADD ./config.yaml /etc/mosdns/config.yaml
ADD ./mosdns-cron-start.sh /mosdns-cron-start.sh
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories&&apk add curl && chmod +x /mosdns-cron-start.sh
VOLUME /etc/mosdns
EXPOSE 53/udp 53/tcp 80/tcp 80/udp
CMD /mosdns-cron-start.sh
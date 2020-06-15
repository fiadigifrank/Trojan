#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
[ ! ${1} ] && echo -e "${red}错误!: 请输入版本号${plain}" && exit 1
getOldVer=$(/etc/trojan/bin/trojan-go -version |grep Trojan-Go |head -n 1|cut -d ' ' -f 2)
getServiceList=$(systemctl list-units --state=running|grep trojan |cut -d ' ' -f 1)
echo -e "${green}当前trojan版本:${getOldVer}${plain}"
for i in ${getServiceList}; do systemctl stop ${i} && echo -e "${yellow}停止trojan服务:${i}${plain}" ; done
[ -d /tmp/trojan ] && rm -rf /tmp/trojan
mkdir /tmp/trojan
wget -O /tmp/trojan/trojan.zip https://github.com/p4gefau1t/trojan-go/releases/download/${1}/trojan-go-linux-amd64.zip && echo -e "${green}下载新版本:${1}${plain}"
unzip /tmp/trojan/*.zip -d /tmp/trojan/
cp -f /tmp/trojan/trojan-go /tmp/trojan/geo* /etc/trojan/bin && echo -e "${green}新版本覆盖安装完毕${plain}"
getNewVer=$(/etc/trojan/bin/trojan-go -version |grep Trojan-Go |head -n 1|cut -d ' ' -f 2)
echo -e "${green}当前trojan版本:${getNewVer}${plain}"
for i in ${getServiceList}; do systemctl start ${i} && echo -e "${yellow}启动trojan服务:${i}${plain}" ; done

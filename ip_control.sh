#!/bin/bash
#
# IP盾构机被控端辅助脚本 by 良辰
#
# Copyright (c) 2020.





# Detect Debian users running the script with "sh" instead of bash
if readlink /proc/$$/exe | grep -q "dash"; then
	echo "This script needs to be run with bash, not sh"
	exit
fi

if [[ "$EUID" -ne 0 ]]; then
	echo "Sorry, you need to run this as root"
	exit
fi

if ! iptables -t nat -nL &>/dev/null; then
	echo "您似乎未安装iptables."
	exit
fi



beikong0_chushihua(){
	if grep -qs "14.04" /etc/os-release; then
	echo "Ubuntu 14.04 is not supported"
	exit
fi

if grep -qs "jessie" /etc/os-release; then
	echo "Debian 8 is not supported"
	exit
fi

if grep -qs "CentOS release 6" /etc/redhat-release; then
	echo "CentOS 6 is not supported"
	exit
fi

	echo "请输入当前机器主网卡名，例如eth0："
			read -p "eth name: " eth_name
	echo "请输入当前机器总带宽速率(单位Mbps)："
			read -p "须为大于0的正整数: " port_speed
	echo "开启iptables转发模块..."
	echo -e "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
	sysctl -p
	echo "正在清空防火墙..."
	iptables -F
	iptables -t nat -F
	echo "正在清空限速规则..."
	iptables -t mangle -F
	echo "正在初始化tc限速(无视报错即可)..."
	tc qdisc del dev "$eth_name" root
	echo "正在tc限速添加根节点..."
	tc qdisc add dev "$eth_name" root handle 1: htb default 1
	tc class add dev "$eth_name" parent 1: classid 1:1 htb rate "$port_speed"mbps
	echo "保存防火墙..."
	if [[ "$os" == "centos" ]]; then
		service iptables save
		echo "安装curl..."
		yum install wget curl ca-certificates -y
	else
		iptables-save > /etc/iptables.up.rules
		echo "安装curl..."
		apt-get install wget curl ca-certificates -y
	fi
	echo "初始化完毕！"
	read -p "是否安装被控端文件(首次执行必须安装)[y/N]" down_files
	if [[ "$down_files" =~ ^[yY]$ ]]; then
		echo "正在下载gost2.11版本"
		wget https://raw.githubusercontent.com/xb0or/iptables-shield/master/gost -O /usr/bin/gost
		chmod +x /usr/bin/gost
		echo "正在下载被控端"
		wget https://raw.githubusercontent.com/xb0or/iptables-shield/master/ip_table -O /usr/bin/ip_table
		chmod +x /usr/bin/ip_table
		echo "正在下载brook"
		wget https://raw.githubusercontent.com/xb0or/iptables-shield/master/brook -O /usr/bin/brook
		chmod +x /usr/bin/brook
	fi
	echo "转发端初始完成！请手动 crontab -e 添加定时任务！"
}
beikong1_chushihua(){
	echo "正在执行初始化，请提前手动放行防火墙！"
	if [[ "$os" == "centos" ]]; then
		echo "安装curl..."
		yum install wget curl ca-certificates -y
	else
		echo "安装curl..."
		apt-get install wget curl ca-certificates -y
	fi
	read -p "是否下载被控端文件(首次执行必须安装)[y/N]" down_files_1
	if [[ "$down_files_1" =~ ^[yY]$ ]]; then
		echo "正在下载gost2.11版本"
		wget https://raw.githubusercontent.com/xb0or/iptables-shield/master/gost -O /usr/bin/gost
		chmod +x /usr/bin/gost
		echo "正在下载被控端"
		wget https://raw.githubusercontent.com/xb0or/iptables-shield/master/iptables_gost -O /usr/bin/iptables_gost
		chmod +x /usr/bin/iptables_gost
	fi
	echo "被控端端初始完成！请手动 crontab -e 添加定时任务！"
}
echo && echo -e " IP盾构机辅助脚本 V1.0.2 修复版


  -- 请注意，${Green_font_prefix}CENOS7系统请先升级iptables${Font_color_suffix}CENOS7系统请先升级iptables，参考：https://www.bnxb.com/linuxserver/27546.html --
  

————————————
 ${Green_font_prefix}1.${Font_color_suffix} 转发机-全局初始化
 ${Green_font_prefix}2.${Font_color_suffix} 落地机-全局初始化" && echo
stty erase '^H' && read -p " 请输入数字 [1-2]:" num
case "$num" in
	1)
	beikong0_chushihua
	;;
	2)
	beikong1_chushihua
	;;
	
	*)
	echo "请输入正确数字 [0-5]"
	;;
esac

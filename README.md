# iptables-shield
小伞IP盾构机 被控脚本修复
## 1.转发机初始化：
## 执行Shell：
```javascript
wget https://raw.githubusercontent.com/xb0or/iptables-shield/master/ip_control.sh && chmod +x ip_control.sh && bash ip_control.sh
```
## 2.手动加定时任务（请自行替换网址和key，注意不要丢掉空格）：

```
*/5 * * * * . /etc/profile;ip_table -url http://baidu.com -key XXXXXXX
```
## 主控端部署完毕，您可以手动执行该命令查看执行是否有问题：
```
ip_table -url http://baidu.com -key XXXXXXX
```

# Gost隧道转发
## 一部分是转发机（国内端），另一部分是落地机（国外端）。

## 1.转发机初始化
## 执行Shell：
```javascript
wget https://raw.githubusercontent.com/xb0or/iptables-shield/master/ip_control.sh && chmod +x ip_control.sh && bash ip_control.sh
```
### 选择 执行选项 《1》。
## 2.手动加定时任务（请自行替换网址和key，注意不要丢掉空格）：

```
*/5 * * * * . /etc/profile;ip_table -url http://baidu.com -key XXXXXXX
```

## 3.落地机初始化(请注意开放防火墙哦)
```
wget https://raw.githubusercontent.com/xb0or/iptables-shield/master/ip_control.sh && chmod +x ip_control.sh && bash ip_control.sh
```
### 选择 执行选项 《2》。

## 3.添加定时任务（请自行替换网址和key，注意不要丢掉空格）
```
*/5 * * * * . /etc/profile;iptables_gost -url http://baidu.com -key XXXXXXX
```

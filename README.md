# RUISU-XX


搬瓦工vps/openvz加速利器FinalSpeed
厘米 2015-12-24 Linux 1,017 次浏览 83条评论

FinalSpeed是高速双边加速软件,可加速所有基于tcp协议的网络服务,在高丢包和高延迟环境下,仍可达到90%的物理带宽利用率,即使高峰时段也能轻松跑满带宽.它的前身是xsocks，今天在一台openvz架构vps上测试了一下效果非常明显，简直是咸鱼翻身。所谓双边加速就是服务端和客户端都要安装，PS：这个不是用来扶墙的，而是可以给ss等扶墙工具加速的。所以如果你经济有限，只能买一台搬瓦工vps，但是又苦于晚高峰时的表现，那么FinalSpeed是最适合你的方案了。

项目Github地址：https://github.com/d1sm/finalspeed

论坛： http://www.ip4a.com/c/131.html
一、服务端安装

注意问题:
服务端会启动iptables,如果服务器修改过ssh端口,请先开放ssh端口,否则可能导致ssh连接失败.
开放端口命令
service iptables start
iptables -A INPUT -p tcp --dport 端口号 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 端口号 -j ACCEPT
service iptables save

一键安装，一键脚本非常方便，我在debian7上安装很顺利
rm -f install_fs.sh
wget  http://fs.d1sm.net/finalspeed/install_fs.sh
chmod +x install_fs.sh
./install_fs.sh 2>&1 | tee install.log

FinalSpeed

如图所示就是安装成功的，FinalSpeed is running.正在运行。运行正常可以直接看第二步。

debian,ubuntu下如果执行脚本出错,请切换到dash,
切换方法: sudo dpkg-reconfigure dash 选no

更新
执行一键安装会自动完成更新.

卸载
sh /fs/stop.sh ; rm -rf /fs

启动
sh /fs/start.sh

停止
sh /fs/stop.sh

重新启动
sh /fs/restart.sh

日志
tail -f /fs/server.log

设置服务端口
默认udp 150和tcp 150 ,由于finalspeed的工作原理,请不要在本机防火墙开放finalspeed所使用的tcp端口.
mkdir -p /fs/cnf/ ; echo 端口号 > /fs/cnf/listen_port ; sh /fs/restart.sh

设置开机启动
chmod +x /etc/rc.local
vi /etc/rc.local
加入
sh /fs/start.sh

每天晚上3点自动重启
crontab -e
加入
0 3 * * *  sh /fs/restart.sh
二、客户端设置
Windows客户端下载

1.服务器必须同时部署FinalSpeed服务端才能进行加速.
2.客户端必须准确设置物理带宽,最终加速的速度不会超过所设置的带宽值,如果设置值高于实际物理带宽会造成丢包和不必要的重传.
3.客户端首选udp协议,如果udp不稳定,请切换到tcp.
4.若服务器为openvz架构（比如搬瓦工）,客户端只能选择udp协议,其他架构同时支持tcp和udp协议.
5.windows客户端使用tcp协议时不兼容锐速,停止锐速后可以正常运行.

加速ss教程（前提是你本地ss已经测试过没问题）
假设服务器IP为10.10.10.10,finalspeed端口为默认150,ss端口为8989.
加速前提ss服务端运行正常,ss客户端也能正常登录.
1.运行FinalSpeed客户端,填写服务器地址 10.10.10.10 .设置带宽，根据你实际带宽设置，比如我这里是10M上下行对等光纤。

FinalSpeed

2.点击添加,增加加速端口,加速端口为ss端口8989,如果为其他端口,请相应修改,本地端口任意,这里是2000 .传输协议UDP

FinalSpeed

3.打开ss客户端,添加服务器,服务器IP为127.0.0.1,服务器端口为加速端口对应的本地端口,这里是2000,然后设置你的ss密码,加密方式.

FinalSpeed

4.确定保存,选择使用刚添加的服务器,并设置浏览器代理,成功连接后,FinalSpeed状态栏会出现"连接服务器成功"提示.更多教程访问作者论坛。

总结：本人实测如果你服务端是manyuser也可以加速，但是你得让每个端口的用户都装上FinalSpeed，太麻烦。所以这个东东最适合的就是经济有限，只能买个搬瓦工等openvz架构的vps自用的同学。

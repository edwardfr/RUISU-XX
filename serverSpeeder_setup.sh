#!/bin/sh
SysName='';
MAC='';
Kernelversion=$(uname -a | awk '{print $3}')
KernelNversion='';
Kernelbversion='';
sysid='';
function install_prelib()
{
	if [ -f "/usr/bin/yum" ];then
		yum install unzip wget ethtool -y
	else
		apt-get install update
		apt-get install unzip wget  ethtool -y
	fi;
}

function get_system_1()
{
	egrep -i "centos" /etc/issue && SysName='CentOS';
	egrep -i "debian" /etc/issue && SysName='Debian';
	egrep -i "ubuntu" /etc/issue && SysName='Ubuntu';
	egrep -i "fedora" /etc/issue && SysName='Fedora';
	[ "$SysName" == ''  ] && get_system_2
}
function get_system_2()
{
	echo ""
	echo " Please select your system"
	select SysName in CentOS CloudLinux CloudLinux_Server Debian Fedora OWLinux Red_Hat_Enterprise SUSE_Linux_Enterprise Ubuntu gentoo;  
	do
		if [ -n "$SysName" ];then
			break
		fi;
	done
}

function reget_system()
{
	echo " - Please select your system"
	select SysName in CentOS CloudLinux CloudLinux_Server Debian Fedora OWLinux Red_Hat_Enterprise SUSE_Linux_Enterprise Ubuntu gentoo;  
	do
		if [ -n "$SysName" ];then
			break
		fi;
	done
	select_v=''
	while [ "$select_v" != 'y' -a "$select_v" != 'n' -a "$select_v" != 'Y' -a "$select_v" != 'N'  ]; do
		read -p "Do you think is right ? OS is $SysName [y/N]" select_v
	done
	[ "$select_v" = "y" -o "$select_v" = "Y" ] && { 
		step2 
	}
	[ "$select_v" = "n" -o "$select_v" = "N" ] && { 
		reget_system
	}
}

function reget_mac()
{
	echo " - Please input your MAC address"
	echo " - Wrong MAC address will make network crash"
	ip link show
	read -p "Please input the mac address:" MAC
	select_v=''
	while [ "$select_v" != 'y' -a "$select_v" != 'n' -a "$select_v" != 'Y' -a "$select_v" != 'N'  ]; do
		read -p "Do you think is right ? MAC is $MAC [y/N]" select_v
	done
	[ "$select_v" = "y" -o "$select_v" = "Y" ] && { 
		step3 
	}
	[ "$select_v" = "n" -o "$select_v" = "N" ] && { 
		reget_mac
	}
}

function step1() # Choose OS
{
	
	get_system_1
	echo ""
	read -p "Do you think is right ? OS is $SysName [y/N]" select_v
	while [ "$select_v" != 'y' -a "$select_v" != 'n' -a "$select_v" != 'Y' -a "$select_v" != 'N'  ]; do
		read -p "Do you think is right ? OS is $SysName [y/N]" select_v
	done

	[ "$select_v" = "y" -o "$select_v" = "Y" ] && { 
		step2 
	}
	[ "$select_v" = "n" -o "$select_v" = "N" ] && { 
		reget_system
	}
}

function reget_kernel()
{
		echo " - Please select your Kernel on the list"
		result=$(wget -q -O- "http://api.ifdream.net/project/sp/Kernel_get.php?d=$SysName&k=$Kernelversion")
		select KernelNversion in $result;  
		do
			if [ -n "$KernelNversion" ];then
				break
			fi;
		done
		select_v=''
		while [ "$select_v" != 'y' -a "$select_v" != 'n' -a "$select_v" != 'Y' -a "$select_v" != 'N'  ]; do
			read -p "Do you think is right ? You select $KernelNversion [y/N]" select_v
		done
		[ "$select_v" = "y" -o "$select_v" = "Y" ] && { 
			step4
		}
		[ "$select_v" = "n" -o "$select_v" = "N" ] && { 
			reget_kernel
		}
}

function reget_version()
{
		echo " - Please select your Kernel on the list"
		result=$(wget -q -O- "http://api.ifdream.net/project/sp/Kernel_download.php?d=$SysName&k=$KernelNversion&action=choose")
		select Kernelbversion in $result;  
		do
			if [ -n "$Kernelbversion" ];then
				break
			fi;
		done
		select_v=''
		while [ "$select_v" != 'y' -a "$select_v" != 'n' -a "$select_v" != 'Y' -a "$select_v" != 'N'  ]; do
			read -p "Do you think is right ? You select $Kernelbversion [y/N]" select_v
		done
		[ "$select_v" = "y" -o "$select_v" = "Y" ] && { 
			step5
		}
		[ "$select_v" = "n" -o "$select_v" = "N" ] && { 
			reget_version
		}
}

function step2() #Get MAC
{
	MAC=$(ip link show | grep ether | head -1 | awk '{print $2}')
	select_v=''
	while [ "$select_v" != 'y' -a "$select_v" != 'n' -a "$select_v" != 'Y' -a "$select_v" != 'N'  ]; do
		read -p "Do you think is right ? MAC is $MAC [y/N]" select_v
	done
	[ "$select_v" = "y" -o "$select_v" = "Y" ] && { 
		step3 
	}
	[ "$select_v" = "n" -o "$select_v" = "N" ] && { 
		reget_mac
	}
}

function step3() #Get The kernel Version
{
	echo " - Please Wait..."
	sleep 1
	result=$(wget -q -O- "http://api.ifdream.net/project/sp/Kernel_get.php?d=$SysName&k=$Kernelversion")
	if [ "$result" = "notfound" ];then
		echo " Sorry , We can't find the serverSpeeder suit this kenrel"
		exit
	fi;
	if [ "$result" = "nobandwitdh" ];then
		echo " Sorry , We can't provide the service at this time"
		echo " Because WE NEED MONEY THIS PROVIDE THIS SERVICE"
		echo " We need help, More details check on http://233.wiki"
		exit
	fi;
	uname -a
	KernelNversion=$(echo $result | awk '{print $1}')
	select_v=''
	read -p "Do you think is right ? We found $KernelNversion [y/N]" select_v
	[ "$select_v" = "y" -o "$select_v" = "Y" ] && { 
		step4 
	}
	[ "$select_v" = "n" -o "$select_v" = "N" ] && { 
		reget_kernel
	}
}

function step4() # Get the License and Kernel
{
	echo " - Please Wait..."
	rm -rf /tmp/diaoji
	mkdir -p /tmp/diaoji
	cd /tmp/diaoji
	wget -q -O license "http://api.ifdream.net/project/server_speeder-lic.php?mac=$MAC&bw=0&year=2038"
	echo " - The serverSpeeder License is save in /tmp/diaoji/license"
	echo " - Please Wait..."
	wget -q -O sysid-64 "http://lib.idc.wiki/install/sysid-64"
	chmod 777 sysid-64
	sysid=$(./sysid-64)
	echo " - The Serial is $sysid"
	Kernelbversion=$(wget -q -O- "http://api.ifdream.net/project/sp/Kernel_download.php?d=$SysName&k=$KernelNversion")
	select_v=''
	while [ "$select_v" != 'y' -a "$select_v" != 'n' -a "$select_v" != 'Y' -a "$select_v" != 'N'  ]; do
		read -p "Do you want use this version serverSpeeder ? Version is $Kernelbversion [y/N]" select_v
	done
	[ "$select_v" = "y" -o "$select_v" = "Y" ] && { 
		step5
	}
	[ "$select_v" = "n" -o "$select_v" = "N" ] && { 
		reget_version
	}
}

function step5()
{
	echo " - Please Wait..."
	wget -q -O acce "http://api.ifdream.net/project/sp/Kernel_download.php?d=$SysName&k=$KernelNversion&action=download&n=$Kernelbversion" 
	echo " - The serverSpeeder Modules is save in /tmp/diaoji/acce"
	echo " 1) Download the Libraries and Dependencies"
	install_prelib 1>>/root/install_sr.log 2>>/root/sr_error.log
	echo " 2) Download the The ZIP"
	wget http://lib.idc.wiki/install/Special/v3.zip 1>>/root/install_sr.log 2>>/root/sr_error.log
	echo " 3) Decompression The ZIP"
	unzip -o v3.zip 1>>/root/install_sr.log 2>>/root/sr_error.log
	echo " 4) Copy Core file"
	sed -i "s/Change By Diaoji/$sysid/g" /tmp/diaoji/apxfiles/etc/config
	mv /tmp/diaoji/acce /tmp/diaoji/apxfiles/bin/acce 1>>/root/install_sr.log 2>>/root/sr_error.log
	mv /tmp/diaoji/license /tmp/diaoji/apxfiles/etc/license 1>>/root/install_sr.log 2>>/root/sr_error.log
	echo " 5) Starting Auto-Installation"
	service serverSpeeder stop 1>>/root/install_sr.log 2>>/root/sr_error.log
	rm -rf /serverspeeder 1>>/root/install_sr.log 2>>/root/sr_error.log
	rm -rf /etc/init.d/serverSpeeder 1>>/root/install_sr.log 2>>/root/sr_error.log
	chattr -ia /serverspeeder/etc/license 1>>/root/install_sr.log 2>>/root/sr_error.log
	chattr -ia /serverspeeder/bin/acce 1>>/root/install_sr.log 2>>/root/sr_error.log
	
	bash install.sh 1>>/root/install_sr.log 2>>/root/sr_error.log
	service serverSpeeder stop
	wget -O /etc/init.d/serverSpeeder http://lib.idc.wiki/install/Special/motherfucker.sh 1>>/root/install_sr.log 2>>/root/sr_error.log
	chmod 777 /etc/init.d/serverSpeeder
	if [ ! -f "/etc/init.d/serverSpeeder" ];then
		
		chkconfig serverSpeeder on 1>>/root/install_sr.log 2>>/root/sr_error.log
		update-rc.d serverSpeeder start 345 1>>/root/install_sr.log 2>>/root/sr_error.log
	fi
	chattr +a /serverspeeder/etc/license
	chattr +a /serverspeeder/bin/acce
	service serverSpeeder start
	result=$(lsmod | grep appex)
	if [ -n "$result" ]; then
		echo " 6) Installation is complete"
	else
		echo " Installation Failed , Please ask some Technical support on google or something"
		echo " If you want to Solve this , to my website http://www.233.wiki/ Look more"
	fi
	echo ""
	echo "---------------- Thanks For"
	echo "Huanmeng : https://github.com/HuanMeng0/ServerSpeederCrackScript (gayhub)"
	echo "Diaoji : Optimization the install step and script "
	echo " - http://www.50kvm.com"
	echo " - http://www.openvzvps.cc"
	echo " - http://myhost.ifdream.net"
	if [ -n "$result" ]; then
		service serverSpeeder status
	fi;
}


function prerun_check()
{
	bit=$(file /sbin/init | grep "32-bit")
	if [ -z "$bit" ];then
		SysBit="x64";
	else
		echo " Sorry , Only Support 64-bit at this time"
		exit
	fi;
	
	if [ -f "/etc/sysconfig/network-scripts/ifcfg-venet0" ]; then 
		if [ -f "/etc/sysconfig/network-scripts/ifcfg-venet0" ]; then 
			echo " - OpenVZ Node Detected"
		else
			echo " Sorry , OpenVZ VPS is limit the kenrel to install serverSpeeder"
			exit
		fi
	fi

	[ -w / ] || {
		echo "You are not running this script as root. Please rerun as root" >&2
		exit 1
	}

}
prerun_check
step1

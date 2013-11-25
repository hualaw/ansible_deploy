#!/bin/bash -x 
 
ps aux |grep zabbix | grep zabbix > /dev/null 
 
if [ "$?" = "0" ];then 
    pkill -9 zabbix_agentd 
fi 
 
test -e /opt/zabbix/ && rm -rf /opt/zabbix/ 
rm -f /etc/init.d/zabbix_*
rm -f zabbix-agent.tar.gz

wget http://114.112.172.222/zabbix-agent.tar.gz
if test -f zabbix-agent.tar.gz
then
	tar -zxf zabbix-agent.tar.gz
	cd zabbix-[1-9]*/
	./configure --prefix=/opt/zabbix --enable-agent  --with-net-snmp  
	make && make install 
fi

#	sed -i 's/\# EnableRemoteCommands=0/EnableRemoteCommands=1/g' /opt/zabbix/etc/zabbix_agentd.conf   
##	sed -i 's/\# LogRemoteCommands=0/LogRemoteCommands=1/g' /opt/zabbix/etc/zabbix_agentd.conf   
#	sed -i 's/Server=127.0.0.1/Server=114.112.172.222/g' /opt/zabbix/etc/zabbix_agentd.conf   
#	sed -i 's/ServerActive=127.0.0.1/ServerActive=114.112.172.222/g' /opt/zabbix/etc/zabbix_agentd.conf   
#	sed -i "s/Zabbix\ server/${HOST}/g" /opt/zabbix/etc/zabbix_agentd.conf  
#	sed -i 's/\# Include=\/opt\/zabbix\/etc\/zabbix_agentd.conf.d/Include=\/opt\/zabbix\/etc\/zabbix_agentd.conf.d/g' /opt/zabbix/etc/zabbix_agentd.conf  
#	sed -i 's/\# UnsafeUserParameters=0/UnsafeUserParameters=1/g' /opt/zabbix/etc/zabbix_agentd.conf   
	
	id zabbix || useradd zabbix -s /sbin/nologin
	 
#	chmod 777 /tmp/zabbix*
	
#	/opt/zabbix/sbin/zabbix_agentd -c /opt/zabbix/etc/zabbix_agentd.conf 

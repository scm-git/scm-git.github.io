# [王孝东的个人空间](https://scm-git.github.io/)
## Linux

* [常用的ssh命令](http://www.open-open.com/lib/view/open1357655816512.html)

* 后台执行命令：nohup
  ```bash
  $ nohup ./check-tomcat.sh > /dev/null 2>&1 &
  ```
  [nohup命令详解](http://www.cnblogs.com/yinzx/p/4658536.html)

* 删除文件名以"-"开头的文件，例如: -foo，可使用一下两种方式：
  ```bash
  $ rm -- -foo
  $ rm ./-foo
  ```
  
* dos转linux，使用vi命令，然后：`set ff=dos（unix）`

* 开机启动：在/etc/rc.d/rc.local文件中增加要开机启动的脚本：
  ```bash
  $ nohup /hpbridge/check-tomcat.sh > /dev/null 2>&1 &
  $ chmod +x rc.local
  ```
  
* 添加公钥到目标主机：
  ```bash
  #Add id_rsa.pub to destination machine:
  $ scp .ssh/id_rsa.pub user@host:~/.ssh/id_rsa.pub_new
  $ ssh user@host <<'ENDSSH'
  >cat ~/.ssh/id_rsa.pub_new >> ~/.ssh/authorized_keys (">" is no need)
  >rm –f ~/.ssh/id_rsa.pub_new
  >ENDSSH
  #input password:
  ```
  还可以直接使用如下命令：
  ```bash
  $ ssh-copy-id user@host
  ```
  
* Linux 设置取消代理：
  ```bash
  $ export http_proxy=web-proxy.sgp.hp.com:8080
  $ export https_proxy=web-proxy.sgp.hp.com:8080
  $ unset http_proxy
  $ unset https_proxy
  ```
  
* ssh执行远程命令或者脚本：
  ```bash
  $ ssh user@remoteNode "cd /home ; ls"  #执行多个命令
  $ ssh user@remoteNode "~/installNess.sh qq-prod amazon" #执行脚本
  ```
  命令必须加双引号，否则，后面的命令将会在本地执行，命令之间用分号隔开
  
* ssh连接时不检测主机key
  ```bash
  $ ssh -o StrictHostKeyChecking=no
  ```

* ssh-copy-id复制当前主机的公钥到目标机器
  ```bash
  $ ssh-copy-id -i ~/.ssh/id_rsa.pub wxd@local_centos2
  ```
  
* 修改centos网络配置：
  ```
  $ vi /etc/sysconfig/network-script/ifcfg-ens33
  TYPE=Ethernet
  PROXY_METHOD=none
  BROWSER_ONLY=no
  BOOTPROTO=dhcp
  DEFROUTE=yes
  IPV4_FAILURE_FATAL=no
  IPV6INIT=yes
  IPV6_AUTOCONF=yes
  IPV6_DEFROUTE=yes
  IPV6_FAILURE_FATAL=no
  IPV6_ADDR_GEN_MODE=stable-privacy
  NAME=ens33
  UUID=22c502c7-0742-4652-9b78-37e71d847f06
  DEVICE=ens33
  ONBOOT=no
  ```
  将最后一行改为yes, `ifcfg-ens33`这个文件可以根据ifconfig得到，查看网络接口名称
  
* Open ports 80 and 8080 on server firewall using the below command: In CentOS
  ```bash
  firewall-cmd –-zone=public –-add-port=8080/tcp -–permanent
  firewall-cmd –-zone=public –-add-service=http –-permanent
  firewall-cmd –-reload  
  ```

* tcpdump Linux抓包命令，[博客](http://www.cnblogs.com/eavn/archive/2010/08/31/1813815.html)
  ```bash
  tcpdump -X host 192.168.1.1 and port 80  # -X选项可以输出内容，指定主机和端口
  ```
  如果出现"tcpdump: USB link-layer type filtering not implemented"，加上网卡名称，如： -i eth0
  
* 查看JVM虚拟机线程数：
  ```bash
  ps -ef | grep java  #查找到想要查看的JVM进程
  top -Hp $PID    #$PID替换为想要查找的进程号
  ```

* 在Ubuntu上使用sh命令执行脚本问题，Ubuntu的sh命令默认是使用dash,与bash并不兼容，因此需要使用/bin/bash命令执行

* sed命令
```
# -n:表示只显示符合条件的行
# -i：直接修改文件，
sed -i 's/hello/Hello/g' file # g表示替换所有的hello
sed -i '/Hello/d' file #表示删除包括Hello的行
sed -i '/^Hello.*/d' file  #删除以Hello开头的行
sed -i '/^Hello/d' file #和上面的一样，删除以Hello开头的行
sed '1d'  #删除第一行
sed '$d'  #删除最后一行
sed '1,3d'  #删除1到3行

# 指令p:显示匹配的行
sed -n '1p' #显示第一行
sed -n '3,$p' #显示第三到最后一行
sed -n '/Hello/p' #显示所有包括Hello的行

#a 追加
sed '$a ABC'  #在最后一行之后追加ABC

#以上命令在mac下报错：sed: 1: "file": command a expects \ followed by text
# mac下需要在-i参数后增加备份文件名，例如：原始文件为aa,-i '_bak'，会将原文件备份为aa_bak，如果不想备份，则输入空字符串：-i ''
sed -i '_bak' '/Hello/d' file #将file备份为file_bak
sed -i '' 's/Hello/hello/g' #不备份
```

* [Linux硬件信息采集](./linux_collect.md)


  

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
  
* 查看JVM虚拟机线程数：
  ```bash
  ps -ef | grep java  #查找到想要查看的JVM进程
  top -Hp $PID    #$PID替换为想要查找的进程号
  ```
  

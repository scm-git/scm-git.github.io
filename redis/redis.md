# [王孝东的个人空间](https://scm-git.github.io/)
## Redis [官网](http://redis.io)

### Install Redis On Amazon AMI
```
[ec2-user@ip-10-0-0-10 ~]$ sudo yum-config-manager --enable epel
[ec2-user@ip-10-0-0-10 ~]$ sudo yum install redis
# Start redis server
[ec2-user@ip-10-0-0-10 ~]$ sudo redis-server /etc/redis.conf
# check redis service status
[ec2-user@ip-10-0-0-10 ~]$ sudo service redis status
# start redis by service
[ec2-user@ip-10-0-0-10 ~]$ sudo service redis start
```

### Install Redis On Ubuntu
```
$ sudo apt install redis
```

### Redis集群搭建
1. 下载redis源码并编译
   ```bash
   mkdir -p /opt/redis/
   cd /opt/redis
   wget http://download.redis.io/releases/redis-4.0.10.tar.gz
   tar -zxvf redis-4.0.10.tar.gz
   cd redis-4.0.10
   make
   ```

2. 启动节点，启动脚本如下：/opt/redis/redis-4.0.10/startRedisCluster
   ```bash
   #!/bin/bash
   for p in {7100..7105}; do cp redis.conf redis-${p}.conf; mkdir -p /home/redis/data/$p; sed -i -e "s/port 6379/port $p/;s/protected-mode yes/protected-mode no/;s/daemonize no/daemonize yes/;s/bind 127.0.0.1/bind 0.0.0.0/;s/dir ./dir \\/home\\/redis\\/data\\/$p/;s/pidfile \\/var\\/run\\/redis_6379.pid/pidfile \\/var\\/run\\/redis_$p.pid/;s/# cluster-enabled yes/cluster-enabled yes/;s/# cluster-config-file nodes-6379.conf/cluster-config-file nodes-$p.conf/;s/# cluster-node-timeout 15000/cluster-node-timeout 15000/;s/appendonly no/appendonly yes/" redis-${p}.conf;  done
   ./src/redis-server redis-7100.conf
   ./src/redis-server redis-7101.conf
   ./src/redis-server redis-7102.conf
   ./src/redis-server redis-7103.conf
   ./src/redis-server redis-7104.conf
   ./src/redis-server redis-7105.conf
   ```

   说明：第一行使用for循环创建端口分别为7100-7105的节点目录及配置，使用sed命令修改配置文件内容

3. 安装ruby
   ```bash
   yum install centos-release-scl-rh -y
   yum install rh-ruby23  -y
   rm -rf /usr/bin/ruby
   ln -s /opt/rh/rh-ruby23/root/usr/bin/ruby /usr/bin/ruby
   ldconfig /opt/rh/rh-ruby23/root/usr/lib64/
   ruby -v
   yum install rubygems -y
   gem install redis
   ```

4. 创建集群
   ```bash
   ip=$(ifconfig  eth0 | grep inet | awk '{print $2}')  #eth0改为网卡名称，如某些虚拟机内的CentOS系统默认是ens33,用ifconfig名称查看即可
   ./src/redis-trib.rb create --replicas 1 $ip:7100 $ip:7101 $ip:7102 $ip:7103 $ip:7104 $ip:7105   #遇到提示输入yes即可
   ```

5. 远程测试端口
   ```
   telnet $ip 7100
   cluster info
   cluster nodes
   quit
   ```

6. 如果远程连接端口不通，而本地可用，则通常需要修改iptables(即使service iptables status输出为inactive也可能不通)
   ```bash
   sudo /sbin/iptables -I INPUT -p tcp -m tcp --dport 7100 -j ACCEPT
   sudo /sbin/iptables -I INPUT -p tcp -m tcp --dport 7101 -j ACCEPT
   sudo /sbin/iptables -I INPUT -p tcp -m tcp --dport 7102 -j ACCEPT
   sudo /sbin/service iptables save
   ```

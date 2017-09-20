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
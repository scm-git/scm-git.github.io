# [王孝东的个人空间](https://scm-git.github.io/)

## Install Oracle JDK8 on Ubuntu
```
$ sudo add-apt-repository ppa:webupd8team/java
$ sudo apt-get update
$ sudo apt-get install oracle-java8-installer
...
#####Important########
To set Oracle JDK8 as default, install the "oracle-java8-set-default" package.
E.g.: sudo apt install oracle-java8-set-default
On Ubuntu systems, oracle-java8-set-default is most probably installed
automatically with this package.
######################
...
```
如果Oracle JDK8不是默认的JDK，可以安装上面提示中的oracle-java8-set-default

## Install Oracle JDK8 on AMI
```
[ec2-user@ip-10-0-0-10 ~]$ wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.rpm"
[ec2-user@ip-10-0-0-10 ~]$ sudo rpm -ivh jdk-8u144-linux-x64.rpm
[ec2-user@ip-10-0-0-10 ~]$ jps -v
```
安装完成之后，如果不知道安装目录在什么地方，可以使用`jps -v`查看

## Download JDK from Oracle Official site
```bash
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.tar.gz
```
如果出现404就在官网上重新复制链接地址，替换掉最后的下载地址即可

## Java
* [QRCodeUtil](./QRCode/QRCode.md)
* [List](./java-List.md)
* [TreeSet](./java-TreeSet.md)
* [Java面试题](./interview.md)
* [Java unicode为12288字符](./Unicode_12288.md)
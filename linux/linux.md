# [王孝东的个人空间](https://scm-git.github.io/)
## Linux

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

* 
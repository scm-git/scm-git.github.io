# [王孝东的个人空间](https://scm-git.github.io/)
## [Ansible 官网](https://www.ansible.com/)
### Install Ansible on Ubuntu
```
$ sudo apt-get install ansible
```

### 配置ansible
安装完成之后，修改`/etc/ansible/hosts`，配置后需要将本机机器的公钥(通常为`~/.ssh/id_rsa.pub`)添加到各远程主机的`~/.ssh/authorized_keys`文件中.
```
$ cat /etc/ansible/hosts
[dev_test_cfn]
10.0.0.11
10.0.0.12
...

[access_sgp]
10.0.1.11
10.0.1.12
...
```

### AWS EC2使用方式
AWS EC2通常是通过pem密钥文件来访问EC2实例，如果你不想每次上传本地机器的公钥到所有远程主机，可以将EC2按的密钥文件分组，使用本地的私钥来访问，我上面的配置就是根据Key来分组的，因此可以按如下方式访问
```
wxd@wangxiaodong:~/main/hpbridge$ ansible access_sgp --private-key=/home/wxd/.ssh/access-sgp.pem -u ec2-user -s -a "pwd"
10.0.0.11 | SUCCESS | rc=0 >>
/home/ec2-user

10.0.0.12 | SUCCESS | rc=0 >>
/home/ec2-user

10.0.0.13 | SUCCESS | rc=0 >>
/home/ec2-user 
```


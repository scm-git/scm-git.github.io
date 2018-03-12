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
* AWS EC2通常是通过pem密钥文件来访问EC2实例，如果你不想每次上传本地机器的公钥到所有远程主机，可以将EC2按的密钥文件分组，使用本地的私钥来访问，我上面的配置就是根据Key来分组的，因此可以按如下方式访问

  ```
  wxd@wangxiaodong:~/main/hpbridge$ ansible access_sgp --private-key=/home/wxd/.ssh/access-sgp.pem -u ec2-user -s -a "pwd"
  10.0.0.11 | SUCCESS | rc=0 >>
  /home/ec2-user
  
  10.0.0.12 | SUCCESS | rc=0 >>
  /home/ec2-user
  
  10.0.0.13 | SUCCESS | rc=0 >>
  /home/ec2-user 
  ```

* 定义变量：如果不想每次都敲很长的命令，可以将一些不变的项以变量的形式放置在hosts文件中
  
  ```
  [dev_test_cfn:vars]
  ansible_ssh_private_key_file=/home/wxd/.ssh/dev-test-cfn.pem
  
  [access_sgp:vars]
  ansible_ssh_private_key_file=/home/wxd/.ssh/access-sgp.pem
  
  [cloud_pie:vars]
  ansible_ssh_private_key_file=/home/wxd/.ssh/cloud-pie.pem
  
  [aws:children]
  access_sgp
  dev_test_cfn
  cloud_pie
  
  [aws:vars]
  ansible_ssh_user=ec2-user
  ```
  这样就为不同的组定义了不同的private key文件，使用ansible命令的时候也可以直接对all进行操作了，不用在ansible命令中分别指定--private-key参数了，`[aws:children]`是定义一个组的子组，而最后的`[aws:vars]`定义了一个父组的变量，这样所有的子组都可以使用这个变量

* Playbook, 一下playbook上传info.sh脚本到目标主机(region), 然后执行该脚本

  ```
  ---
    -
      hosts: "region"
      tasks:
        -
          copy: src=/opt/ansible/info.sh dest=/opt owner=root group=root mode=0644
          name: "copy shell to client"
        -
          register: info_info
          command: sh /opt/info.sh
          name: "execute info.sh to get info info"
  ```

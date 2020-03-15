# [王孝东的个人空间](https://scm-git.github.io/)
## [Docker](https://www.docker.com/)
### 1.[Install And Use](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-centos-7)
```bash
$ curl -fsSL https://get.docker.com/ | sh
$ curl -fsSL https://get.docker.com/ | sh
$ sudo systemctl status docker
$ docker help
$ docker COMMAND --help
$ docker info
$ docker run hello-world
$ docker search centos
$ docker pull centos
$ docker run centos
$ docker images
$ docker run -it centos
$ docker commit -m "your comments" -a "author name" container-id repository/new_image_name
$ docker ps
$ docker ps -a
$ docker ps -l
$ docker stop container-id
# push docker imamge, need login first
$ docker login -u docker-registry-username
$ docker push docker-registry-username/docker-image-name
```

### Docker Machine
Windows或者Mac需用借助虚拟机来实现docker服务器相关功能，而本地仅仅是连接到docker的虚拟机服务器；所以需要依赖virtual box虚拟机，然后可以通过docker-machine来管理
```
# 使用docker-machine 创建一个docker服务端环境， 名称为default
# 这个命令会通过virtual box拉起一个带有docker服务端的虚拟机环境；默认的driver为virtual box，可以通过--driver使用其他的，比如vmware的fusion等
# 另外这条命令通常会从https://github.com/boot2docker/boot2docker/releases/download/v19.03.5/boot2docker.iso 地址下载虚拟机启动的iso镜像文件，可能需要翻墙才能下载，所以，可能还需要配置代理
# export http_proxy=http://proxy_ip:port
# export https_proxy=http://proxy_ip:port
$ docker-machine create default

$ # 指定客户端需要连接的docker服务端地址(因为是在virtual box的虚拟机中)；下面这条命令其实就是执行了下面4个export(也就是linux的环境变量设置而已，直接运行docker-machine env default可以看到如下输出)
$ # export DOCKER_TLS_VERIFY="1"
$ # export DOCKER_HOST="tcp://192.168.99.100:2376"
$ # export DOCKER_CERT_PATH="/Users/wangxiaodong/.docker/machine/machines/default"
$ # export DOCKER_MACHINE_NAME="default"
$ eval $(docker-machine env default)

```

### 2.Cgroup(control group)
Cgroup是Linux内核的一个特性，用于限制和隔离一组进程对系统资源的使用，这些资源主要包括CPU,内存,block I/O和网络带宽
```bash
# 挂载cgroupfs
$ mount -t cgroup -o cpuset cpuset /sys/fs/cgroup/cpuset

# 查看cgroupfs
$ ls /sys/fs/cgroup/cpuset
total 0
-rw-r--r--. 1 root root 0 Mar 18 05:36 cgroup.clone_children
--w--w--w-. 1 root root 0 Mar 18 05:36 cgroup.event_control
-rw-r--r--. 1 root root 0 Mar 18 05:36 cgroup.procs
-r--r--r--. 1 root root 0 Mar 18 05:36 cgroup.sane_behavior
-rw-r--r--. 1 root root 0 Mar 18 05:36 cpuset.cpu_exclusive
-rw-r--r--. 1 root root 0 Mar 18 05:36 cpuset.cpus

# 创建cgroup
$ mkdir /sys/fs/cgroup/cpuset/child

# 配置cgroup，以下配置限制这个cgroup的进程只能在0号CPU上运行，并且只会从0号内存节点分配内存
$ echo 0 > /sys/fs/cgroup/cpuset/child/cpuset.cpus
$ echo 0 > /sys/fs/cgroup/cpuset/child/cpuset.mems

# 配置当前进程,将当前进程ID写入tasks文件，就可以把进程移动到这个Cgroup中；$$表示当前进程
$ echo $$ > /sys/fs/cgroup/cpuset/child/tasks
```

#### cgroup 子系统
* 1.cpuset子系统：为一组进程分配指定的CPU和内存节点
* 2.cpu子系统：配置CPU的占用率
* 3.cpuacct子系统：统计各个Cgroup CPU的使用情况
* 4.memory子系统：配置Cgroup所能使用的内存上限
* 5.blkio子系统：配置Cgroup的磁盘I/O带宽
* 6.devices子系统：配置Cgroup对设备的访问权限

### 3.Namespace
Namespace 是将内核的全局资源做封装，使每个Namespace都有一份独立的资源，因此不同的进程在各自的Namespace内对同一种资源的使用不会互相干扰
Linux内核的6中Namespace:
* IPC:
* Network:;
* Mount:
* PID
* UTS:
* User
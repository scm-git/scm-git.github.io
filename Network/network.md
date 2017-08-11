# [王孝东的个人空间](https://scm-git.github.io/)
## 计算机网络
### 1. OSI/RM网络结构
OSI/RM为7层网络结构：
* 应用层
* 表示层
* 会话层
* 传输层
* 网络层
  * 路由器
  * 三层交换机
* 数据链路层
  * 计算机网卡
  * 网桥
  * 二层交换机
* 物理层
  * 同轴电缆(目前很少使用了)
  * 光纤
  * 双绞线 (最常用的网卡网络接口，俗称水晶头：RJ-45)
  * 集线器(Hub)
  * 中继器(Repeater)
### 2. TCP/IP网络结构
TCP/IP为4层或者5层网络结构
* 应用层
* 传输层
* 网际互联层
* 网络访问层(4层结构)
    * 数据链路层(5层)
      * MAC子层
      * LLC子层
    * 物理层(5层)
### 3. 计算机网卡
计算机网卡属于数据链路层设备，目前主要包括以下两大类：
#### 3.1 有线以太网卡
* 按与主机接口分：
  * PCI接口
  * PCMCIA接口
  * PCI-X接口
  * PCI-E接口
* 按与网络接口分，即网卡所支持的传输介质类型
  * 双绞线(最常用的，双绞线连接器俗称水晶头，RJ-45)
  * 同轴电缆(目前很少使用了)
  * 光纤(光纤连接器常见的有四种：ST,SC,FC,LC)
* 网卡主机接口位数
  * 32位PCI接口快速以太网卡
  * 纯64位千兆以太网卡
  * 兼容32位的64位以太网卡
* 所支持的以太网标准
  * 10/100Mbps自适应快速以太网卡
  * 10/100/1000Mbps自适应千兆以太网卡
  * 纯1000Mbps光纤千兆以太网卡
#### 3.2 WLAN无线网卡
* 台式机通常选用PCI或者USB接口的WLAN无线网卡
* 笔记本通常选用PCMCIA和USB两种接口类型的WLAN无线网卡
### 4. 网桥
网桥用于连接同一逻辑网段(三层概念，即网络ID一样)中不同物理网段(按地理位置划分)的二层设置

### 常用命令(网络相关)
* `ip link show` #显示网络接口(网卡),等价的命令还有`ip a`, `ifconfig -a`

  ```
  [root@localhost ~]# ip a                                                         
  1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN              
      link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00                        
      inet 127.0.0.1/8 scope host lo                                               
         valid_lft forever preferred_lft forever                                   
      inet6 ::1/128 scope host                                                     
         valid_lft forever preferred_lft forever                                   
  2: ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
      link/ether 00:50:56:8a:61:c4 brd ff:ff:ff:ff:ff:ff                           
      inet 15.114.100.42/21 brd 15.114.103.255 scope global dynamic ens192         
         valid_lft 702817sec preferred_lft 702817sec                               
      inet6 fe80::250:56ff:fe8a:61c4/64 scope link                                 
         valid_lft forever preferred_lft forever                                   
  ```

* ping -b 子网的最大IP #会广播该子网内所有可用设备(当你的ping命令ping了该子网的最大IP或者最小IP时，命令会提示你是否想发送广播),因此可用通过ping最大子网来检查该子网内的其他已分配IP地址; 例如：

  ```
  [root@localhost ~]# ping 15.114.103.255                             
  Do you want to ping broadcast? Then -b                              
  [root@localhost ~]# ping -b 15.114.103.255                          
  WARNING: pinging broadcast address                                  
  PING 15.114.103.255 (15.114.103.255) 56(84) bytes of data.          
  64 bytes from 15.114.96.58: icmp_seq=1 ttl=255 time=0.857 ms        
  64 bytes from 15.114.96.73: icmp_seq=1 ttl=255 time=0.911 ms (DUP!) 
  64 bytes from 15.114.96.52: icmp_seq=1 ttl=255 time=0.974 ms (DUP!) 
  64 bytes from 15.114.96.83: icmp_seq=1 ttl=255 time=0.987 ms (DUP!) 
  64 bytes from 15.114.102.46: icmp_seq=1 ttl=255 time=0.997 ms (DUP!)
  64 bytes from 15.114.96.75: icmp_seq=1 ttl=255 time=0.986 ms (DUP!) 
  64 bytes from 15.114.96.76: icmp_seq=1 ttl=255 time=1.06 ms (DUP!)  
  64 bytes from 15.114.96.53: icmp_seq=1 ttl=255 time=1.08 ms (DUP!)  
  64 bytes from 15.114.96.1: icmp_seq=1 ttl=255 time=1.33 ms (DUP!)   
  64 bytes from 15.114.96.71: icmp_seq=1 ttl=255 time=1.34 ms (DUP!)  
  64 bytes from 15.114.100.1: icmp_seq=1 ttl=64 time=1.91 ms (DUP!)   
  64 bytes from 15.114.102.52: icmp_seq=1 ttl=64 time=1.99 ms (DUP!)  
  64 bytes from 15.114.100.3: icmp_seq=1 ttl=64 time=1.98 ms (DUP!)   
  64 bytes from 15.114.102.51: icmp_seq=1 ttl=64 time=2.01 ms (DUP!)  
  64 bytes from 15.114.100.12: icmp_seq=1 ttl=64 time=2.12 ms (DUP!)  
  ```
* ifconfig命令解释：
  
  ```
  [root@localhost ~]# ifconfig ens192
  ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500  # UP表示启用，RUNNING已连接网线, MULTICAST支持组播
          inet 15.114.100.42  netmask 255.255.248.0  broadcast 15.114.103.255 # IP地址，子网掩码，广播地址
          inet6 fe80::250:56ff:fe8a:61c4  prefixlen 64  scopeid 0x20<link> #IPv6地址
          ether 00:50:56:8a:61:c4  txqueuelen 1000  (Ethernet)  #物理地址
          RX packets 30374869  bytes 2072273190 (1.9 GiB)   # 接收包数量及总大小统计
          RX errors 0  dropped 0  overruns 0  frame 0       # 接收错误情况
          TX packets 489983  bytes 944974485 (901.1 MiB)    # 发送包数量及总大小统计
          TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0    # 发送错误统计        
  ```
* 根据以上广播子网掩码和广播地址，求CIDR： 将子网掩码和IP转换为二进制，然后网络ID部分保持一致，即可求出CIDR，比如上面例子中的CIDR为`15.114.96.0/21`,广播地址即为该子网的最大IP地址

  
  


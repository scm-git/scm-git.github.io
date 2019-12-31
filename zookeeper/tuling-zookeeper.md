# Zookeeper
## 分布式系统的节点协调问题
1. 服务发现：挂掉节点/新增节点 调用方如何知道
2. 定时任务执行节点选举
3. 幂等性

## zookeeper节点类型（4种） 
* 持久节点
* 临时节点
* 持久顺序节点
* 临时顺序节点
* znode: 节点，树形存储，类似文件系统，但是没有目录/文件的区分，所有节点都一样，节点可以有子节点 (临时节点除外) 客户端可以通过调用api实时查看,或者由zk通知客户端
* 临时节点下不能再创建子节点，且客户端连接断开后，临时节点会被删除，常用于服务发现，心跳等场景

## 常用命令
* help
* create /tmp
* get -w /tmp  监听节点  #只会监听一次，每次变更后需要重新发起监听，监听数据
* ls -w /tmp 监听父节点 #也是只监听一次，监听子节点(增，删)，不监听数据
* stat -w /tmp # 监听属性，相当于前两个监听相加

**-w 监听， -R 遍历所有子节点**

## 节点acl
1. schema认证模型
   * world
   * ip
   * auth
   * digest
2. id:
   * anyone: 预定义ID
3. permission权限位
   * c -- CREATE 可以创建子节点
   * d -- DELETE 可以删除子节点
   * r -- READ  可以读取节点数据及显示子节点列表
   * w -- WRITE 可以设置节点数据
   * a -- ADMIN 可以设置节点访问控制列表权限
4. acl相关命令：
   * getAcl
   * setAcl
   * setAcl /tmp world:anyone:cdrwa
   * setAcl /tmp ip:ip地址/地址段:cdrwa
   * setAcl /tmp auth:用户名:密码:cdrwa
      
**权限只针对当前节点，不会对子节点生效**

## Zookeeper 集群部署
1. 集群配置
   ```
   server.1=127.0.0.1:2887:3887
   server.2=127.0.0.1:2888:3888
   server.3=127.0.0.1:2889:3889
   #server.3=127.0.0.1:2889:3889:observer #设置为observer类型节点
   ```
2. 创建各自的dataDir
3. 在dataDar下创建myid文件，写入自己的ID：1/2/3

### Zookeeper 集群角色
1. leader  主节点， 用于写入数据，通过选举产生，如果挂掉会重新选举产生
2. follower  次节点， 用于读取数据，且是主节点的备选节点，并拥有投票权
3. observer 次级主节点， 用于读取数据，没有投票权，不能被选为主节点，并且在计算集群可用状态时不会将observer节点计算在内

```
# 连接集群，用逗号隔开，连接一个或多个效果是一样的
zkCli.sh -server 127.0.0.1:2181,127.0.0.1:2182
# 查看节点状态
zkServer.sh status conf/zoo1.cfg 
```

### leader选举机制：
1. 投票机制，
   * 第一轮投票给自己，
   * 后面投票给myid比自己大的相邻节点，如果有节点票数过半，选举结束
   * 未产生leader时，节点状态为looking
   * zxid取大者 
2. 选举触发
   * 服务启动时
   * 半数以上节点无法和leader通信时

### 数据同步机制
1. proposal leader --> follower 
2. ACK follower --> leader
3. commit leader --> follower

leader没有产生之前，zookeeper无法提供服务

### ZXID
保证数据一致性
节点数据同步：根据ZXID 64位， 高32+低32；  每次选举leader会对高32位+1，并清空低32位； 每次数据变更，ZXID都会+1
























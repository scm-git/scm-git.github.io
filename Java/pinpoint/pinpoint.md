# Pinpoint调研
## 快速入门
1. 下载Pinpoint
   ```
   $ git clone https://github.com/naver/pinpoint.git
   $ ./mvnw install -Dmaven.test.skip=true
   ```
2. 安装并启动HBase
   ```
   # 下载并启动
   $ quickstart/bin/start-hbase.sh
   # 初始化数据表
   $ quickstart/bin/init-hbase.sh
   ```
如果是Windows需要自己下载HBase,并将解压后的目录放到quickstart/hbase/hbase下

3. 启动pinpoint
   ```
   # 启动collector
   $ quickstart/bin/start-collector.sh
   # 启动测试app
   $ quickstart/bin/start-testapp.sh
   # 启动pinpoint web
   $ quickstart/bin/start-web.sh
   ```

## 简介
1. 组件
   * HBase (存储)
   * Pinpoint Collector （收集器）
   * Pinpoint Web (web界面)
   * Pinpoint Agent (agent，作为被监控应用的jar包一起加载)

2. 安装HBase, 下载，解压，配置HBASE_HOME，增加$HBASE_HOME/bin到path路径下
   * 安装完成之后，执行: `hbase shell pinpoint/hbase/script` 创建相关schema
   * 启动hbase，`$HBASE_HOME/bin/start_hbase.sh`，可以查看hbase管理界面，默认端口:16010

3. 从源码构建，需要配置JAVA 6/7/8版本的JDK，并配置环境变量：(可以直接下载二进制包，不必配置一下环境变量)
   * JAVA_HOME: 配置为JDK8的目录
   * JAVA_6_HOME JDK6的安装目录(推荐1.6.0_45(45是JDK6的最后一个版本))
   * JAVA_7_HOME JDK7的安装目录(推荐1.7.0_80(80是JDK7的最后一个版本))
   * JAVA_8_HOME JDK8的安装目录

4. 部署pinpoint collect: 直接放到tomcat即可(使用默认配置)

5. 部署pinpint web: 直接放到tomcat即可(使用默认配置)

6. Pinpoint Agent: 解压pinpoint-agent-xxx.tar.gz，放在任意目录下，启动java应用时追加以下参数即可：
   ```
   -javaagent:$AGENT_PATH/pinpoint-bootstrap-$VERSION.jar
   -Dpinpoint.agentId
   -Dpinpoint.applicationName
   ```
   例如：tomcat应用： 将以上三个参数配置在catalina.sh文件中，如：
   ```
   CATALINA_OPTS="$CATALINA_OPTS -javaagent:/root/pinpoint-agent/pinpoint-bootstrap-1.8.0.jar -Dpinpoint.agentId=gateway-agent-9001 -Dpinpoint.applicationName=gateway"
   ```

   **通常被监控的app并没有和pinpoint collector在同一个机器上，因此一般需要修改agent的配置项：`profiler.collector.ip`用于指定collector所在机器的IP，配置文件在pinpoint-agent目录下的`pinpoint.config`**

## [pinpoint技术概述(中文)](https://github.com/skyao/learning-pinpoint/blob/master/design/technical_overview.md)

## pinpoint数据结构
* Span
* Trace
* TraceId
* TransactionId:一次完整调用的ID，全局唯一
* spanId:当前节点的ID
* parentSpanId:调用者的spanId

# 坑
* 不能使用IDEA启动app，会出现如下错误,导致无法看到结果：
  ```
  [WARN ](o.j.n.c.SimpleChannelHandler :76 ) EXCEPTION, please implement com.navercorp.pinpoint.rpc.server.PinpointServerAcceptor$PinpointServerChannelHandler.exceptionCaught() for proper handling.
    java.io.IOException: Connection reset by peer
    at sun.nio.ch.FileDispatcherImpl.read0(Native Method)
    at sun.nio.ch.SocketDispatcher.read(SocketDispatcher.java:39)
    at sun.nio.ch.IOUtil.readIntoNativeBuffer(IOUtil.java:223)
    at sun.nio.ch.IOUtil.read(IOUtil.java:192)
    ...
  ```

  这段日志位于agent目录下的log/${agentId}.log文件中，如果发现有其他问题，也可以查看该日志文件排查问题

* 开通防火墙端口时需要开通两个udp协议，默认的的端口是9994，9995，9996；可以使用agent目录下的script/networktest.sh脚本测试网络端口配置，配置成功的结果如下(三个SUCCESS)：
   ```
   2018-09-18 17:39:23 [INFO ](com.navercorp.pinpoint.bootstrap.config.DefaultProfilerConfig) configuration loaded successfully.
    UDP-STAT:// vm1
        => 192.168.10.128:9995 [SUCCESS]

    UDP-SPAN:// vm1
        => 192.168.10.128:9996 [SUCCESS]

    TCP:// vm1
        => 192.168.10.128:9994 [SUCCESS]
   ```

* 不同的APP(即使是相同应用的不同实例)不能指定相同的agentId，否则会导致两个都不可用

* 不能修改pinpoint-agent目录下的pinpoint-agent-1.8.0.jar这个文件的名称，必须保持这个格式，否则会报错，源码校验了格式

* bogon问题导致hbase无法启动：

   

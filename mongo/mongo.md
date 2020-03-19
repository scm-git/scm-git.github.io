# [王孝东的个人空间](https://scm-git.github.io/)
## Mongo

### Install On Mac
MongoDB分社区版和企业版，安装方法都是一样的，直接安装企业版
1. 手动[下载企业版](https://www.mongodb.com/download-center/enterprise?jmp=docs)二进制包，解压安装
```
$ mkdir -p /usr/loacal/mongodb
$ tar -C /usr/local/mongodb -zxvf mongodb-osx-ssl-x86_64-enterprise-4.0.6.tgz
$ #添加mongo安装目录/bin到PATH变量中,.bash_profile或者.bashrc
$ echo "EXPORT PATH=$PATH:/usr/local/mongodb/mongodb-osx-x86_64-enterprise-4.0.6/bin" >> ~/.bash_profile
$ source ~/.bash_profile
```

2. 启动
```
#直接输入下面的命令，但是进程会运行在当前终端，关掉终端，进程也结束了
$ mongod
# 后台运行,增加--fork参数和--logpath参数(指定日志输出文件)
$ mongod --fork --logpath /usr/local/mongodb/mongod.log

# 连接mongo服务器，注意指定认证库，admin库的用户对所有库生效
$ mongo 192.168.1.101:27017/app_db -u root -p 123456 --authenticationDatabase admin
```

3. 常用命令：
   ```
   # 查看所有库
   $ show dbs
   # 创建或切换数据库，没有就创建
   use DATABASE_NAME
   # 查看collecitons，类似于mysql的table
   $ show collections
   # 查看mycollection集合中的数据; find中传入json参数过滤，具体方法参考教程文档
   $ db.mycollection.find()
   # 插入数据
   $ db.mycollecion.insert();
   ```

# [王孝东的个人空间](https://scm-git.github.io/)
## Maven
### 常见问题
* 1.删错某个pom文件的所有依赖包：当下载依赖包出问题时，尤其是公司网络没有配置代理时下载jar出错，而maven又不能自动重新下载有效jar包时，可以用以下命令清除后重新下载，避免一个一个的手动删除：
  ```bash
  mvn dependency:purge-local-repository -DreResolve=false
  ```

### install到本地库
```
$ mvn install:install-file -Dfile=F://jar/push-sdk-2.2.15.jar -DgroupId=com.xiaomi -DartifactId=push-sdk -Dversion=2.2.15 -Dpackaging=jar

$ mvn install:install-file -Dfile=F://jar/bcprov-jdk16-1.45.0.jar -DgroupId=org.bouncycastle -DartifactId=bcprov-jdk16 -Dversion=1.45.0 -Dpackaging=jar -e
```

### deploy到服务器库
```
$ mvn deploy:deploy-file -Dmaven.test.skip=true -Dfile=F://jar/push-sdk-2.2.15.jar -DrepositoryId=maven-releases -DgroupId=com.xiaomi -DartifactId=push-sdk -Dversion=2.2.15 -Dpackaging=jar -Durl=http://127.0.0.1:8081/repository/maven-releases/

$ mvn install:install-file -Dfile=F://jar/bcprov-jdk16-1.45.0.jar -DgroupId=org.bouncycastle -DartifactId=bcprov-jdk16 -Dversion=1.45.0 -Dpackaging=jar -DrepositoryId=maven-releases -Durl=http://127.0.0.1:8081/repository/maven-releases/
```

### 注意：
1. -DrepositoryId=maven-releases： 为settings的文件中设置的server对应的id，此ID设置了server对应的用户名密码。
2. 需要nexus服务器开启redeploy 权限。
3. settings文件配置server、用户名和密码。
4. 命令行中 -DrepositoryId 设置为settings文件中server的id名称。上传根据此查找对应的用户名和密码。 
  

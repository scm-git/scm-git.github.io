# [王孝东的个人空间](https://scm-git.github.io/)
## Spring [官网](http://spring.io)

### Spring MVC
1. [数据绑定](./springmvc.md)

### Spring Boot
1. [yaml配置复杂对象](./springboot.md)

### Jasypt加密
  ```
  D:\servers\repository\org\jasypt\jasypt\1.9.2>java -cp jasypt-1.9.2.jar org.jasypt.intf.cli.JasyptPBEStringEncryptionCLI input="mysqlpassword" password=jasyptPassword algorithm=PBEWithMD5AndDES
  
  	----ENVIRONMENT-----------------
  
  	Runtime: Oracle Corporation Java HotSpot(TM) 64-Bit Server VM 25.65-b01
  
  
  
  	----ARGUMENTS-------------------
  
  	algorithm: PBEWithMD5AndDES
  	input: mysqlpassword
  	password: jasyptPassword
  
  
  
  	----OUTPUT----------------------
  ```
  
  说明：
  
  ```
  IUFi1V14rjkWAiLHuFrC2ym9+sZdWUGl
  	spring配置文件中：ENC(IUFi1V14rjkWAiLHuFrC2ym9+sZdWUGl)
  	
  	jasypt.encryptor.algorithm=PBEWithMD5AndDES
  	jasypt.encryptor.password=jasyptPassword
  	variable.mysqlPassword=ENC(znyr+NCPGVekXTRbN5M2NkRQkGLrPUK7)
  	spring.datasource.password=${variable.mysqlPassword}
  	// 或者直接如下
  	spring.datasource.password=ENC(znyr+NCPGVekXTRbN5M2NkRQkGLrPUK7)
  ```
  
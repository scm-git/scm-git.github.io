# [王孝东的个人空间](https://scm-git.github.io/)
## JPA

### Spring JPA
* JPA的完整配置示例：

  ```
  spring:
    jpa:
      show-sql: true
      database: mysql
      hibernate:
        ddl-auto: create
        naming:
          physical-strategy: org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
      properties:
        hibernate:
          dialect: org.hibernate.dialect.MySQL5Dialect
    datasource:
      url: jdbc:mysql://localhost:3306/mydatabase?useUnicode=true&amp;characterEncoding=utf8
      username: admin
      password: ******
      driver-class-name: com.mysql.jdbc.Driver
      testWhileIdle: true
      validationQuery: SELECT 1
  ```
  
* JPA配置自动创建表时，按指定的表名及列名创建(指定大小写)，需要用如下策略：`spring.jpa.hibernate.naming.physical-strategy=org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl`  
* `spring.jpa.hibernate.ddl-auto`: none, vlidate, update, create, create-drop
  * validate: validate the schema, makes no changes to the database.
  * update: update the schema.
  * create: creates the schema, destroying previous data.
  * create-drop: drop the schema at the end of the session
  * none: 生产环境应该用none
  * 对于hsqldb, h2, derby默认值为create-drop, 其他数据库的默认值为none

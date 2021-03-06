# [王孝东的个人空间](https://scm-git.github.io/)
## Database
### 1. MySQL
* 常规方式安装
  * Ubuntu
  ```
  $ sudo apt install mysql-server
  ```
* Docker方式安装

### MySQL创建用户并授权
```
mysql> CREATE USER 'dbuser'@'localhost' IDENTIFIED BY 'yourpassword';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'dbuser'@'localhost' WITH GRANT OPTION;
mysql> GRANT ALL PRIVILEGES ON *.* TO 'dbuser'@'%' WITH GRANT OPTION;
mysql> CREATE USER 'wxd'@'192.168.1.3' IDENTIFIED BY 'password';
mysql> GRANT ALL PRIVILEGES ON wxddatabase.* to 'wxd'@'192.168.1.3' WITH GRANT OPTION;
mysql> CREATE USER 'appuser'@'192.168.1.%' IDENTIFIED BY 'password';
mysql> GRANT SELECT, INSERT, UPDATE, DELETE ON appdatabase.* to 'appuser'@'192.168.1.%' WITH GRANT OPTION;
```
**最后一个用户的host是一个地址段，表示该地址段内的host都可以连接，并且最后一个用户的权限只有appdatabase数据库上的的增删改查操作**
更多的privilege可以参考官网：[MySQL privilege](https://dev.mysql.com/doc/refman/5.7/en/privileges-provided.html)

* 如果root用户无法通过其他机器登录，通常是需要授权
```
mysql>  CREATE USER 'root'@'%' IDENTIFIED BY 'yourpassword';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
```

* 查看用户权限
```
mysql> show grants for root;
+-------------------------------------------------------------+
| Grants for root@%                                           |
+-------------------------------------------------------------+
| GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION |
+-------------------------------------------------------------+
1 row in set (0.00 sec)
```

* 创建好用户之后，可以查询mysql.user表来查看已创建的用户：
```
mysql> select * from user where user = 'root' and host = '%' \G
*************************** 1. row ***************************
                  Host: %
                  User: root
           Select_priv: Y
           ...
          Trigger_priv: Y
Create_tablespace_priv: Y
              ssl_type: 
            ssl_cipher: 
           x509_issuer: 
          x509_subject: 
         max_questions: 0
           max_updates: 0
       max_connections: 0
  max_user_connections: 0
                plugin: mysql_native_password
 authentication_string: *6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9
      password_expired: N
 password_last_changed: 2017-08-25 08:17:01
     password_lifetime: NULL
        account_locked: N
1 row in set (0.00 sec)
```

* 因此可以通过修改mysql.user表来修改用户的登录权限:
```
mysql> update user set host = 'localhost' where user = 'wxd' and host = '%';
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0
mysql> select host, user from user;
+-----------+------------------+
| host      | user             |
+-----------+------------------+
| %         | root             |
| localhost | debian-sys-maint |
| localhost | mysql.session    |
| localhost | mysql.sys        |
| localhost | root             |
| localhost | wxd              |
+-----------+------------------+
6 rows in set (0.00 sec)
```

* 如果要让修改立即生效，则需要执行`flush privileges`，需要有相关权限的用户才能执行该操作
```
mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
```

* 修改用户密码：
```
mysql> alter user 'wxd'@'localhost' identified by '654321';
Query OK, 0 rows affected (0.01 sec)
```

* 直接修改mysql.user表，修改是需要用password()加密，操作中mysql出现一个warning，查看warning发现，password已经被废弃，可能会在后续的版本中被删除，因此这种方式仅作为了解
```
mysql> update user set authentication_string = password('abcefg') where user = 'wxd' and host = '%';
Query OK, 1 row affected, 1 warning (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 1
mysql> show warnings;
+---------+------+-------------------------------------------------------------------+
| Level   | Code | Message                                                           |
+---------+------+-------------------------------------------------------------------+
| Warning | 1681 | 'PASSWORD' is deprecated and will be removed in a future release. |
+---------+------+-------------------------------------------------------------------+
1 row in set (0.00 sec)
```

* 修改当前用户密码：
```
mysql> alter user user() identified by '654321';
Query OK, 0 rows affected (0.00 sec)
```
**mysql的帐户是有host和user联合唯一确认一个用户，因此相同的user名称，不同的host可以有不同的密码，不同的权限，从本质上看，这是两个不同的帐户**

* 删除用户
```
mysql> drop user 'wxd'@'localhost';
Query OK, 0 rows affected (0.00 sec)
```

* 如果已经对root或者其他帐户赋予了权限，其他机器仍然无法登录，通常需要修改MySQL的配置文件，配置文件路径通常为`/etc/mysql/my.cnf`或者`/etc/mysql/mysql.conf.d/mysqld.cnf`，注释掉`bind-address=127.0.0.1`，然后重启服务`sudo service mysql restart`

---

### MySQL常用命令
* `show table status`查看表信息，下面的\G表示以列形式显示

  ```
  mysql> show table status like 'printer' \G                     
  *************************** 1. row *************************** 
             Name: printer                                       
           Engine: InnoDB                                        
          Version: 10                                            
       Row_format: Compact                                       
             Rows: 1875                                          
   Avg_row_length: 174                                           
      Data_length: 327680                                        
  Max_data_length: 0                                             
     Index_length: 81920                                         
        Data_free: 0                                             
   Auto_increment: 2157                                          
      Create_time: 2016-11-24 12:38:42                           
      Update_time: NULL                                          
       Check_time: NULL                                          
        Collation: utf8_general_ci                               
         Checksum: NULL                                          
   Create_options:                                               
          Comment:                                               
  1 row in set (0.00 sec)                                        
  ```

---

### MySQL性能分析
* 使用SHOW PROFILE；默认是关闭的，开启profile，在MySQL连接会话中执行`set profiling = 1;`，主要命令`show profiles`，`show profile [type] on query 2`，示例如下：
  type:
  * ALL -- 显示所有开销信息
  * BLOCK IO -- 显示块IO相关开销
  * CONTEXT SWITCHES -- 上下文切换相关信息
  * CPU -- 显示CPU相关开销信息
  * IPC -- 显示发送和接收相关开销信息
  * MEMORY  -- 显示内存相关开销信息
  * PAGE FAULTS -- 显示页面错误相关信息
  * SOURCE  -- 显示和source_function, source_file, source_line相关的开销信息
  * SWAPS   -- 显示交换次数相关信息
  
  ```
  mysql> show profiles;                                                  
  +----------+------------+------------------------------------------+   
  | Query_ID | Duration   | Query                                    |   
  +----------+------------+------------------------------------------+   
  |        1 | 0.11317700 | select * from nicer_but_slower_film_list |   
  +----------+------------+------------------------------------------+   
  1 row in set, 1 warning (0.03 sec)                                     
                                                                         
  mysql> show profile for query 1;                                       
  +----------------------+----------+                                    
  | Status               | Duration |                                    
  +----------------------+----------+                                    
  | starting             | 0.000053 |                                    
  | checking permissions | 0.052765 |                                    
  | Opening tables       | 0.000169 |                                    
  | checking permissions | 0.000002 |                                    
  | checking permissions | 0.000001 |                                    
  | checking permissions | 0.000001 |                                    
  | checking permissions | 0.000001 |                                    
  | checking permissions | 0.000001 |                                    
  | checking permissions | 0.000280 |                                    
  | init                 | 0.000076 |                                    
  | checking permissions | 0.000004 |                                    
  | checking permissions | 0.000001 |                                    
  | checking permissions | 0.000001 |                                    
  | checking permissions | 0.000001 |                                    
  | checking permissions | 0.000020 |                                    
  | System lock          | 0.000010 |                                    
  | optimizing           | 0.000002 |                                    
  | optimizing           | 0.000008 |                                    
  | statistics           | 0.000079 |                                    
  | preparing            | 0.000015 |                                    
  | Creating tmp table   | 0.017341 |                                    
  | Sorting result       | 0.000014 |                                    
  | statistics           | 0.000009 |                                    
  | preparing            | 0.000007 |                                    
  | executing            | 0.000273 |                                    
  | Sending data         | 0.000012 |                                    
  | executing            | 0.000001 |                                    
  | Sending data         | 0.022663 |                                    
  | Creating sort index  | 0.019060 |                                    
  | end                  | 0.000008 |                                    
  | query end            | 0.000007 |                                    
  | removing tmp table   | 0.000144 |                                    
  | query end            | 0.000004 |                                    
  | closing tables       | 0.000002 |                                    
  | removing tmp table   | 0.000064 |                                    
  | closing tables       | 0.000008 |                                    
  | freeing items        | 0.000016 |                                    
  | removing tmp table   | 0.000004 |                                    
  | freeing items        | 0.000039 |                                    
  | cleaning up          | 0.000015 |                                    
  +----------------------+----------+                                    
  40 rows in set, 1 warning (0.06 sec)                                   
  ```
* 使用SHOW STATUS，执行前可以先执行`flush status;`；清空之前的状态

  ```
  mysql> flush status;
  mysql> show status where variable_name like 'Handler%' or Variable_name like 'Created%';
  +----------------------------+-------+
  | Variable_name              | Value |
  +----------------------------+-------+
  | Created_tmp_disk_tables    | 0     |
  | Created_tmp_files          | 0     |
  | Created_tmp_tables         | 0     |
  | Handler_commit             | 1     |
  | Handler_delete             | 0     |
  | Handler_discover           | 0     |
  | Handler_external_lock      | 2     |
  | Handler_mrr_init           | 0     |
  | Handler_prepare            | 0     |
  | Handler_read_first         | 1     |
  | Handler_read_key           | 1     |
  | Handler_read_last          | 0     |
  | Handler_read_next          | 0     |
  | Handler_read_prev          | 0     |
  | Handler_read_rnd           | 0     |
  | Handler_read_rnd_next      | 2045  |
  | Handler_rollback           | 0     |
  | Handler_savepoint          | 0     |
  | Handler_savepoint_rollback | 0     |
  | Handler_update             | 0     |
  | Handler_write              | 0     |
  +----------------------------+-------+
  21 rows in set (0.00 sec)
  ```
* 使用EXPLAIN查看执行计划，下面是分别查询有索引和无索引列的执行计划结果：

  ```
  mysql> explain select * from printer where sn = 'xxx' \G      
  *************************** 1. row ***************************
             id: 1                                              
    select_type: SIMPLE                                         
          table: printer                                        
           type: ALL                                            
  possible_keys: NULL                                           
            key: NULL                                           
        key_len: NULL                                           
            ref: NULL                                           
           rows: 1875                                           
          Extra: Using where                                    
  1 row in set (0.00 sec)                                       
                                                                
  mysql> explain select * from printer where ep_email = 'xxx' \G
  *************************** 1. row ***************************
             id: 1                                              
    select_type: SIMPLE                                         
          table: printer                                        
           type: ref                                            
  possible_keys: idx_ep_email                                   
            key: idx_ep_email                                   
        key_len: 387                                            
            ref: const                                          
           rows: 1                                              
          Extra: Using index condition                          
  1 row in set (0.00 sec)                                       
  ```
  * type: 关联类型或访问类型，system > const > eq_ref > ref > range > index > ALL
  * key: 使用的索引
  * key_len: 使用的索引长度，使用联合索引中的不同字段时，长度为不同；key_len的计算规则：
    * 字符串： char(n)：n字节长度；varchar(n): 2字节存储字符传长度，如果是utf-8，则长度是3n+2
    * 数值类型：tinyint - 1 字节，smallint - 2 字节， int - 4 字节， bigint - 8 字节
    * 时间类型： date - 3 字节， timestamp - 4 字节， datetime - 8 字节
    * 如果字段允许为null, 需要额外1字节记录是否为null
  * ref: const(where id = 1), ref(where film_actor.film_id = film.id)
  * rows: 扫描的行数
  * Extra: 额外的补充说明： 
    * using index： 使用覆盖索引，select列中的字段全在索引中，无需再通过索引读取row
    * using condition: 查询列不完全被索引覆盖，可能使用了索引的前导列
    * using where: 查询列未被索引覆盖，例如：select name from film; 
    * Select tables optimized away：mysql已内部优化，例如 select min(id) from film;
    * using filesort： 排序，使用了临时表
    * using temporary: 使用临时表
* `SHOW GLOBAL STATUS`
* `SHOW PROCESSLIST`，在末尾加上\G可以垂直的方式输出结果，方便结合linux命令排序
* `mysql -e 'SHOW PROCESS LIST\G' | grep State: | sort | uniq -c | sort -rn`
* 慢查询日志，默认路径：/var/log/mysql/slow-query.log

---

### MySQL Schema与数据类型优化
* 选择优化数据类型的简单原则
  * 更小的通常更好：选择你认为不会超过范围的最小类型
  * 简单就好：例如：1.存时间使用MySQL内建的数据类型而不是字符串；2.存IP使用整型
  * 尽量避免使用NULL：尤其是需要建索引的列
* 整数类型
  * TINYINT, SMALLINT, MEDIUMINT, INT, BIGINT分别占用8,16,24,32,64位存储空间，可存储值的范围-2<sup>(N-1)</sup>到2<sup>(N-1)</sup>，N为存储空间位数
  * NUMERIC, INTEGER, BOOL等都是MySQL为了兼容性而支持的别名
  * MySQL可以为整型指定宽度，例如INT(11),对大多数应用并没有意义，它不会限制值的合法范围；只是规定了MySQL的交互工具(例如客户端)显示字符的个数。对于存储和计算来说，INT(1)和INT(20)是相同的
* 实数
  * FLOAT和DOUBLE，分别占32和64位，可以指定精度，非精确计算
  * DECIMAL，精确计算，但是空间和计算开销较高
  * **MySQL推荐使用BIGINT代替浮点数和DECIMAL，如果需要将计算精确到百万分之一，可以将结果乘以一百万； 这样可以避免浮点数的计算不精确和DECIMAL精确计算代价高的问题**
* 日期和时间
  * DATETIME：占8位
  * TIMESTAMP：占4位，显示依赖于时区，MySQL服务器，操作系统以及客户端连接都有时区设置；性能比DATETIME更好，MySQL更推荐使用TIMESTAMP
* IP地址：存IP地址应该尽可能使用整型，而不使用VARCHAR(15)；整型的效率更高，且MySQL提供INET_ATON()和INET_NTOA()函数来转换表示方法
* 计数器表： 如果一个计算器表只有一行记录，用来记录网站访问次数；每次更新时会导致该行上有一个排它锁而只能串行更新，因此可以增加100行这样的记录，每次随机更新一行，统计的时候加上所有的行的值：sum(cnt)
* ALTER TABLE：可以直接修改.frm文件，但不是官方推荐的方法；因为直接使用MODIFY修改，会导致MySQL创建一个新表，并将旧表的数据复制到新表，如果表特别大的话，会导致耗时非常长，而且这个过程会锁表，会导致无法操作该表；另外还可以有以下两种方式：
  * “影子拷贝”：创建一张和源表无关的新表，并将新表修改为所需要的数据结构，然后通过重命名和删除交换两张表。Facebook的数据库运维团队提供"online schema change"工具完成影子拷贝
  * 使用一个备库，在备库上完成修改后，再切换主库

---

### MySQL索引
* MySQL索引类型：
  * B-Tree：如果不特别指明，通常所说的索引就是B-Tree索引。节点会保存子节点的指针；使用B-Tree需要注意的地方：
    * 创建多列索引时一定要注意列顺序。
    * 如果不按照索引的最左列开始查找，则无法使用索引，例如一个索引：Key(LAST_NAME,FIRST_NAME,AGE)，如果WHERE字句中直接查找FIRST_NAME，则无法使用索引
    * 不能跳过索引中的列，也就是无法通过索引直接查找LAST_NAME=XXX AND AGE=XX
    * 如果查询中某个列有范围查询，则后边的列无法再使用索引优化查询
    * 辅助索引中存储的数据是数据行的主键，所以如果通过辅助索引查询，需要再次通过主键定位数据行
  * 哈希索引：基于哈希表实现，只有精确匹配所有列的查询才有效。对每一行数据，存储引擎都会对所有的索引列计算一个hash code. 哈希索引无法用于排序，且只支持等值查询(=),不支持>=,<=等操作。
    * 一个常用的哈希索引场景为：存储大量URL时，可以对URL列使用哈希索引(CRC32)，这样通过URL查询时，效率非常高。但是如果表特别大，CRC32可能会导致大量的哈希冲突，可以考虑自己实现一个简单的64位哈希函数。一个简单的办法是使用MD5()函数返回值的一部分作为自定义的哈希函数
  * 空间数据索引(R-Tree)： MyISAM表支持空间索引
  * 全文索引：全文索引是一种特殊类型的索引，它查找的是文本中的关键词，而不是直接比较索引中的值。全文搜索和其他几类索引的匹配方式完全不一样，它更类似于搜索引擎做的事情，而不是简单的WHERE条件匹配。在相同的列上同时创建全文索引和基于值的B-Tree索引不会有冲突，全文索引适用于MATCH AGAINST操作，而不是普通的WHERE条件查询
  * 其他索引
* 对于数据字典表之类的小表，完全不需要索引，因为全表扫描更高效；而对于中到大型表，使用索引就非常有效
* 对于网站SESSION，可以存储长度为8的前缀索引，通常能够显著提升性能
* 对于email，可以将email反向存储，以便与使用索引
* 聚簇索引： 并不是一种单独的索引类型，而是一种索引存储方式。InnoDB的聚簇索引是在同一个结构中保存了B-Tree索引和数据行
  * 优点： 可以降低磁盘I/O，数据访问更快
  * 缺点： 更新聚簇索引列的代价很高，可能导致全表扫描变慢
* 索引可以减少锁定的行
* 索引查询优化：
  * 全值匹配
  * 最左前缀法则 -- 联合索引
  * 不要在索引列上使用函数，包括字符串数字隐式转换
  * 存储引擎不能使用索引中范围条件右边的列
  * 尽量使用覆盖索引（只访问索引列的查询，减少select * 查询）
  * 不等于(<>, !=)不能使用索引，尽量避免
  * is null, is not null也不能使用索引
  * like 前导查询可以用索引， 前模糊无法使用索引('%ABC')
  * 少用in或or，用它查询时，mysql不一定使用索引，mysql内部优化器会根据检索比例，表大小等多个因素整体评估是否使用索引（范围查询优化）
  * 范围查询优化，例如 `age >= 1 and age <= 2000`,这个可能就不会索引； 可以优化为多个小范围查询
  * 覆盖索引原则： 如果查询的列都是辅助索引上的列，则可能走索引，如果不是，则需要通过辅助索引重新定位的主键索引，然后在读取数据行；所以某些索引列查询可能并不一定走索引
* trace工具用法，开启trace工具会影响mysql性能，所以只能临时开启分析sql使用，用完之后立即关
  ```
  mysql> set session optimizer_trace="enabled=on", end_markers_in_json=on; -- 开启trace
  mysql> select * from employees where name > 'a' order by position;
  mysql> select * from information_schema.OPTIMIZER_TRACE;

  查看trace字段：
  ```

---

### 优化查询
* **切分查询**，将一个大量数据的SQL操作切分为多个小量数据的SQL操作；如果用一个大的SQL语句一次性完成的话，可能需要一次性锁住很多数据，占满整个事务日志，耗尽系统资源，阻塞其他小的但很重要的查询
* **分解关联查询**，有如下好处：
  * 让缓存的效率更高
  * 将查询分解后，执行单个查询可以减少锁的竞争
  * 在应用层做关联，可以更容易对数据库进行拆分，更容易做到高性能和可扩展
  * 查询本身效率也可能得到提升
  * 可以减少冗余记录的查询
* 优化COUNT()查询
  * COUNT(*)统计行数
  * COUNT(COLUMN_NAME)，统计该列不为NULL的总数
* 优化关联查询
  * 确保ON或者USING字句中的列上有索引：**通常只需要在关联顺序中的第二个表的相应列上创建索引**
  * 确保GROUP BY 和 ORDER BY中的表达式只涉及到一个表中的列，这样MySQL才有可能使用索引来优化
  * 升级MySQL时需要注意，关联语法，运算符优先级等其他可能发生变化的地方
* 优化子查询
  * 优化子查询最重要的建议就是尽量使用**关联查询**代替
* 一个查询的完整过程：
  1. 客户端发送一条查询给服务器
  2. 服务器先检查查询缓存，如果命中了缓存，则立刻返回存储在缓存中的结果。否则进入下一个阶段
  3. 服务器端进行SQL解析、预处理、再由优化器生成对应的执行计划
  4. MySQL根据优化器生成的执行计划，调用存储引擎的API来执行查询
  5. 将结果返回给客户端
* 对于一个MySQL连接，或者说一个线程，任何时刻都有一个状态，该状态表示了MySQL当前正在做什么，可以通过`SHOW FULL PROCESSLIST`查询每个连接的状态，这些状态的意义如下：
  * Sleep
  * Query
  * Locked
  * Analyzing and statistics
  * Copying to tmp table [on disk]
  * Sorting result
  * Sending data
* 分区表
  * MySQL分区表是一个独立的逻辑表，但是底层是由多个物理字表组成。一个表最多只能有1024个分区。
  * MySQL分区表支持根据范围分区，还可以根据键值、哈希和列表分区
  * 使用分区表可能遇到的问题
    * NULL值，NULL值会使分区过滤无效
    * 分区列和索引列不匹配
    * 选择分区的成本可能很高
    * 打开并锁住所有底层表的成本可能很高
    * 维护分区的成本可能很高
  * 使用EXPLAIN查看分区使用情况`EXPLAIN PARTITIONS`
* 深入优化
  * Order by 与 Group by
    ```
    -- 对于索引(name, age, position)
    mysql > select * from employees where name = 'LiLei' order by age;  -- where中的name和order by中的age都会走索引，因为，name,age符合最左前缀原则
    mysql > select * from employees where name = 'LiLei' order by position; -- where中的name会走索引，但是order by中的position不会走索引，跳过了age
    mysql > select * from employees where name = 'LiLei' order by age,position; -- where中的name和order by中的age, position会走索引；符合索引树的字段顺序
    mysql > select * from employees where name = 'LiLei' order by position,age; -- where中的name会走索引，但是order by中的position,age不会走索引；不符合索引树的字段顺序； order by 的顺序不能调换，不像where的等值查询可以被优化为正确的顺序
    mysql > select * from employees where name = 'LiLei' and age = 18 order by position,age; -- where中的name,age和order by中的position, age都会走索引，此处会优化order by 中的age字段，因为age已经是一个常量，是无效的排序字段，所以满足索引字段顺序
    mysql > select * from employees where name = 'LiLei' order by age asc, position desc; -- where中的name会走索引，order by中的age asc,position desc不会走索引，因为order by要求的排序方式与索引的排序方式不一致，无法使用索引，索引无法走索引
    mysql > select * from employees where name in ('LiLei', 'HanMeimei') order by age, position; -- in 范围查询，走不走索引并不是一定的， order by子句也不会走索引，因为范围查找之后的字段是不会走索引的
    mysql > select * from employees where name in ('LiLei', 'HanMeimei') order by age, position; -- in 范围查询，走不走索引并不是一定的， order by子句也不会走索引，因为范围查找之后的字段是不会走索引的
    mysql > select * from employees where name > 'a' order by name; -- 范围查询，不一定走索引
    mysql > select name, age, position from employees where name > 'a' order by name; -- 会走索引，因为查询列满足索引覆盖原则

    -- 思考： select * from table_1 order by id desc; 与 select * from table_1 order by create_date desc;
    ```
  * mysql支持两种方式的排序: `filesort`和`index`, Using index指MySQL扫描索引本身完成的排序。index效率高，filesort效率低
  * order by满足两种情况会使用Using index: 1. order by语句使用索引最左前列；2. where子句和order by子句的条件列组合满足最左前缀列
  * 尽量在索引列上完成排序，遵循索引建立(索引创建的顺序)时的最左前缀法则
  * 如果order by的条件不在索引列上，就会产生filesort
  * 能用覆盖索引尽量用覆盖索引
  * group by与order by类似，其实质是先排序后分组，遵循索引创建顺序的最左前缀法则。对于group by的优化如果不需要排序的可以加上order by null禁止排序
  * where高于having，能写在where中的条件就不要去having限定了
* Using filesort文件排序原理
  * 单路排序：是一次性取出满足条件的所有字段，然后在sort buffer中进行排序；用trace工具可以看到filesort_summary.sort_mode信息里显示<sort_key, additional_fields>或者<sort_key, packed_additional_fields>
  * 双路排序（又叫回表排序）：首先根据相应的条件取出相应的排序字段和可以直接定位行数据的行id，然后在sort buffer中进行排序，排序完后需要再次回表取回其他需要的字段；用trace工具可以看到filesort_summary.sort_mode信息里显示<sort_key, rowid>
  * MySQL通过比较变量max_length_for_sort_data(默认1024字节)的大小和需要查询的字段总大小来判断使用哪种排序模式: 如果查询的字段总长度 > max_length_for_sort_data，则使用双路排序，小于则使用单路排序
* 分页优化
  * 考虑这个查询： `select * from employee limit 100000,5;`, SQL先查询出100005条记录，然后丢弃掉前100000条，留下最后5条，所以性能会比较低， 当主键自增且连续时，等价于:  `select * from employee where id > 100000 limit 5;`
  * 考虑这个查询(大表的后面几页查询)： `select * from employee order by name limit 100000, 5`; (name上有索引)，优化： `select * from employee e inner join (select id form employee order by name limit 100000, 5) ed on e.id = ed.id;` 先通过索引覆盖查询得到100000开始的5行，因为select中只有id，所以走索引覆盖，而不用全表扫描，然后外层查询再通过ID去定位行记录，所以扫描行数大大降低，从而提高效率
* 关联查询优化
  * 表连接关联查询两种常用算法：
    * 嵌套循环连接(Nested-Loop Join)算法： 大表的连接字段上有索引，MySQL通常使用这种算法
    * select * t1 inner join t2 on t1.name = t2.name; -- 查看查询计划，可以看到先查询数据量小的那一张表，在查询大的表(小表驱动大表，先执行的表叫驱动表，另一张表叫被驱动表)
      * 从小表中读取一行数据，
      * 读取关联字段name，到大表中查询
      * 取出大表中满足条件的行，跟小表中获取的结果合并，作为结果返回给客户端
      * 重复三面3步
    * 整个过程扫描的数据行数就是： 小表行数+大表能匹配上的行数；
  * 基于块的嵌套连接循环连接(Block Nested-Loop Join)算法: 连接字段上没有索引时使用该算法
    * 算法流程
      * 把小表(驱动表)的数据读入join_buffer中，  
      * 把大表中的数据逐行读出，跟join_buffer中数据做对比
      * 返回满足join条件的数据
  * 结论： 用小表驱动大表，可以减少行扫描次数从而减少磁盘IO，对关联字段增加索引， 当你明确知道哪个表示小表的时候，可以使用small_table straight_join big_table的方式(但是straight_join只适用于inner_join,不适用于left join, right join); 但是使用straight_join一定要慎重，MySQL执行引擎可能还会参考其他因素来判断
* in和exists优化
  * 原则： 小表驱动大表
  * in: `select * from A where id in (select id from B)`: 当B的数据集小于A表的时候，in 优先于 exists
  * exists: `select * from A where exists (select 1 from B where b.id = a.id)`: 当A表的数据集小于B表的数据集时，exists 优先于 in
* count(*)查询优化； 以下count的性能一次递减， 而且选择二级索引，因为二级索引数据量更小(叶子节点只有id)
  * count(1): 
  * count(name):  
  * count(*): 
  * count(id): 
  * **对于大表的count，可以将行数放入redis(但是可能不准确，可以通过定时任务每隔一段时间更新总算，这样就只有某一个时间段不准)，或者另起一个计数表来存储行数(数据表和计数表放在一个事务里，可以保证一致性)**


  
    
---

### MySQL数据库迁移
[MySQL数据库迁移好的文章](http://www.cnblogs.com/advocate/archive/2013/11/19/3431606.html)
* **迁移之前最好使用一个新库，以避免迁移失败后无法恢复原有的库**
* 亲测过直接传输数据文件的方式迁移
  * 源数据库： Windows 10 MySQL server 5.7
  ```
  wxd@wangxiaodong:~$ mysql -u root -h 192.168.1.3 -p
  Enter password: 
  Welcome to the MySQL monitor.  Commands end with ; or \g.
  Your MySQL connection id is 6
  Server version: 5.7.12-log MySQL Community Server (GPL)
  ```
  
  * 目标数据库： Ubuntu 17.04 MySQL Server 5.7
  ```
  wxd@wangxiaodong:~$ mysql -uroot -p
  Enter password: 
  Welcome to the MySQL monitor.  Commands end with ; or \g.
  Your MySQL connection id is 5
  Server version: 5.7.19-0ubuntu0.17.04.1 (Ubuntu)
  ```

* 步骤：
  * 将源服务器中的文件打包，打包的目录包括需要迁移的库(一个库对应一个目录，如下图)，以及ibdata1文件
  ![数据库目录](./db1.png)
  ```
  wanxiaod@WANXIAOD4 MINGW64 /c/ProgramData/MySQL/MySQL Server 5.7/Data
  $ tar -zcvf data.tar cloud_print_1 cloud_print_pie ibdata1 sakila spring_demo world
  ```
  
  * 上传到目标服务器：
  ```
  wanxiaod@WANXIAOD4 MINGW64 /c/ProgramData/MySQL/MySQL Server 5.7/Data
  $ scp data.tar wxd@wangxiaodong:~/
  wxd@wangxiaodong's password:
  data.tar                                                                              100% 6789KB   6.6MB/s   00:01
  ```
  
  * 在目标服务器上解压data.tar文件，并放置在mysql的目录中`/var/lib/mysql`，解压后可能需要修改文件的所属用户/组; **该步骤之前请先备份ibdata1文件，以免迁移失败后，无法恢复原来的数据库文件**
  ```
  root@wangxiaodong:/var/lib/mysql/data# tar -xf data.tar 
  root@wangxiaodong:/var/lib/mysql/data# chown -R mysql:mysql *
  root@wangxiaodong:/var/lib/mysql/data# mv * ../
  root@wangxiaodong:/var/lib/mysql/data# cd ..
  root@wangxiaodong:/var/lib/mysql# rm -rf data/
  root@wangxiaodong:/var/lib/mysql# ll
  总用量 188472
  drwx------ 10 mysql mysql     4096 8月  25 17:07 ./
  drwxr-xr-x 74 root  root      4096 8月  24 23:20 ../
  -rw-r-----  1 mysql mysql       56 8月  24 23:20 auto.cnf
  drwxr-xr-x  2 mysql mysql     4096 8月   4 17:54 cloud_print_1/
  drwxr-xr-x  2 mysql mysql     4096 7月  27  2016 cloud_print_pie/
  -rw-r--r--  1 root  root         0 8月  24 23:21 debian-5.7.flag
  -rw-r-----  1 mysql mysql      546 8月  25 15:28 ib_buffer_pool
  -rw-r--r--  1 mysql mysql 79691776 8月  25 16:45 ibdata1
  -rw-r-----  1 mysql mysql 50331648 8月  25 16:45 ib_logfile0
  -rw-r-----  1 mysql mysql 50331648 8月  24 23:20 ib_logfile1
  -rw-r-----  1 mysql mysql 12582912 8月  25 15:28 ibtmp1
  drwxr-x---  2 mysql mysql     4096 8月  24 23:20 mysql/
  drwxr-x---  2 mysql mysql     4096 8月  24 23:20 performance_schema/
  drwxr-xr-x  2 mysql mysql     4096 7月  22  2016 sakila/
  drwxr-xr-x  2 mysql mysql     4096 9月  26  2016 spring_demo/
  drwxr-x---  2 mysql mysql    12288 8月  24 23:21 sys/
  drwxr-xr-x  2 mysql mysql     4096 7月  22  2016 world/
  ```
  
  * 最后重新登录数据库查看是否能查询到相关的库和数据：
  
    ```
    mysql> show databases;
      +--------------------+
      | Database           |
      +--------------------+
      | information_schema |
      | cloud_print_1      |
      | cloud_print_pie    |
      | mysql              |
      | performance_schema |
      | sakila             |
      | spring_demo        |
      | sys                |
      | world              |
      +--------------------+
      9 rows in set (0.00 sec)
      
      mysql> use sakila;
      Reading table information for completion of table and column names
      You can turn off this feature to get a quicker startup with -A
      Database changed
      
      mysql> select * from actor limit 2;
      +----------+------------+-----------+---------------------+
      | actor_id | first_name | last_name | last_update         |
      +----------+------------+-----------+---------------------+
      |        1 | PENELOPE   | GUINESS   | 2006-02-15 04:34:33 |
      |        2 | NICK       | WAHLBERG  | 2006-02-15 04:34:33 |
      +----------+------------+-----------+---------------------+
      2 rows in set (0.00 sec)
    ```
  
  * 能够查询到新的数据库中的数据，说明迁移成功。
  
---

### MySQL配置
* MySQL的配置文件通常为`/etc/my.cnf`或者`/etc/mysql/my.cnf`，你也可以通过`mysqld`命令查看默认的配置文件路径：
```
wxd@wangxiaodong:~$ mysqld --verbose --help | grep -A 1 "Default options"
mysqld: Can't change dir to '/var/lib/mysql/' (Errcode: 13 - Permission denied)
2017-08-26T09:14:29.180829Z 0 [Warning] Changed limits: max_open_files: 1024 (requested 5000)
2017-08-26T09:14:29.180893Z 0 [Warning] Changed limits: table_open_cache: 431 (requested 2000)
Default options are read from the following files in the given order:
/etc/my.cnf /etc/mysql/my.cnf ~/.my.cnf 
wxd@wangxiaodong:~$ 
```

* MySQL的配置文件可以使用版本控制系统管理起来，便于追踪每次修改以及失败后快速回滚

* MySQL的绝大多数据配置都不用修改，默认的就是最优的，但是有两个选项通常是需要修改的，这两个配置项的默认值通常都比较小：
  * innodb_buffer_pool_size，5.7版本的默认值为128M，这个值通常可以设置为系统内存的3/4，3/4只是一个简单的原则，如果你的系统上除了MySQL还要运行其他应用，则需要减掉其他应用的总内存，如果只运行MySQL,而且的系统内存并不是特别大的话(如16G以内)，则可以简单的设置为`16G×0.75`。Amazon RDS就是根据这个原则设置的该值
  * innodb_log_file_size，5.7版本的默认值为48M， 而Amazon RDS设置的值是固定的128M

* MySQL基本配置项
  * max_connections 该配置项设置MySQL server的最大连接数，默认值为100，这个值通常都太小，不能满足需求，根据自己的需要可以适当的调大这个值，500是一个比较合理的起点值
  * tmp_table_size和max_heap_table_size 这两个配置项控制使用memory引擎的内存临时表能使用多大的内存，如果这两个值太小，当临时表需要的内存大小超过该值时，会将表转换为MyISAM磁盘表

* 安全和稳定相关的配置
  * max_allow_packet 放置服务器发送太大的包，也会控制多大的包可以被接收。如果你需要复制数据，可能需要修改该配置项
  * max_connect_errors 由于网络问题，客户端配置错误或者其他问题可能导致短时间内不断的尝试连接，如果超过该配置次数，客户端可能会被列入黑名单，然后将无法连接，直到主机刷新缓存
  * skip_name_resolve 禁用dns查找，如果关闭了dns查找，则需要把基于主机名的授权改为IP地址、通配符或者特定主机名“localhost”
  
* 下面的选项可以控制复制行为，并且对防止备库出问题有帮助
  * read_only 这个选项禁止没有特权的用户在备库做变更，只接受从主库传输过来的变更，不接受从应用过来的变更。强烈建议把备库设置为只读模式
  * skip_slave_start 阻止MySQL自动启动复制。因为在不安全的崩溃或其他问题出现后，启动复制是不安全的，因此需要禁用自动启动复制，用户需要手动检查并确认安全后再自行启动
  * slave_net_timeout 这个选项控制备库发现跟主库的连接已经失败并且需要重连之前等待的时间。默认值是一个小时，太长了，推荐设置为1分钟或者更短
  * sync_master_info、sync_relay_log、sync_relay_log_info
  
* [MySQL在线配置工具](http://tools.percona.com)

---

### MySQL事务、隔离级别、多版本并发控制(MVCC)
* 事务保证的数据的ACID特性
* 隔离级别
  * READ UNCOMMITTED(未提交读)
  * READ COMMITTED(提交读)
  * REPEATABLE READ(可重复读)
  * SERIALIZABLE(可串行化)
* MySQL InnoDB默认的隔离级别是REPEATABLE READ(可重复读)，MySQL InnoDB使用MVCC来避免REPEATABLE READ的幻读问题
* MVCC简单说明
  * MVCC是行级锁的一个变种，但是它在很多情况下避免了加锁的操作，因此开销更低
  * 各种数据库，包括Oracle, PostgreSQL等都实现了MVCC，但是各自的实现机制不尽相同，因为MVCC没有一个统一的实现标准
  * MVCC只会在REPEATABLE READ和READ COMMITTED两个隔离级别下工作。另外两个隔离级别和MVCC不兼容，因为READ UNCOMMITTED总是读取最新的数据行，而SERIALIZABLE则会对所有读取的行加锁
* InnoDB的MVCC，是通过在每行记录后面保存两个隐藏的列来实现的。这两个列，一个保存了行的创建时间，一个保存了行的过期时间(或删除时间)。当然并不是实际的时间值，而是系统版本号(system version number)。当开始一个新的事务，系统版本号都会递增，事务开始时刻的系统版本号会作为当前开始事务的版本号，用来和查询到的每行记录的版本号进行比较。下面看一下InnoDB在REPEATABLE READ隔离级别下MVCC对增删改查的具体操作：
  * **SELECT** InnoDB会根据以下两个条件检查每行记录：
    1. InnoDB只查找版本早于当前事务版本的数据行(也就是行的系统版本号小于或等于事务的系统版本号)，这样可以确保事务读取的行要么是事务开始之前已经存在的，要么是当前事务自身插入或者修改过的
    2. 行的删除版本要么未定义，要么大于当前事务版本号。这可以确保事务读取到的行，在事务开始之前未被删除
  * **INSERT** InnoDB为新插入的每一行保存当前系统版本号作为行版本号
  * **DELETE** InnoDB为删除的每一行保存当前版本号作为行删除标识
  * **UPDATE** InnoDB会插入一行新记录，并保存当前系统版本号为行版本号，同时保存当前系统版本号到原来的行作为行删除标识

---    

### mysql_config_editor MySQL Configuration Utility
* mysql_config_editor 执行该命令可以设置mysql登录选项，包括密码，后面登录的时候可以不用再次输入密码等，该命令会生成一个文件.mylogin.cnf，Unix系统会将该文件保存在宿主目录下(~/.mylogin.cnf)，Windows会保存在%APPDATA%\MySQL目录下
```
wxd@wangxiaodong:~$ mysql_config_editor set --login-path=client --host=localhost --user=wxd --password
Enter password:
wxd@wangxiaodong:~$ 
```

* 这里login-path设置为client，client是默认的选项，执行`mysql`的时候可以直接连接该配置的MySQL server， 如果有多个MySQL server需要连接，可以继续配置：

  ```
  wxd@wangxiaodong:~$ mysql_config_editor set --login-path=wanxiaod4 --host=192.168.1.3 --user=root --password
  Enter password: 
  wxd@wangxiaodong:~$ mysql --login-path=wanxiaod4
  Welcome to the MySQL monitor.  Commands end with ; or \g.
  Your MySQL connection id is 4
  Server version: 5.7.12-log MySQL Community Server (GPL)
  
  Copyright (c) 2000, 2017, Oracle and/or its affiliates. All rights reserved.
  
  Oracle is a registered trademark of Oracle Corporation and/or its
  affiliates. Other names may be trademarks of their respective
  owners.
  
  Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
  
  mysql>
  ```

* 连接非client的server就需要指定`--login-path`选项
```
$ mysql --login-path=wanxiaod4
```

* 可以使用`mysql_config_editor print --all`命令查看配置
```
wxd@wangxiaodong:~$ mysql_config_editor print --all
[client]
user = wxd
password = *****
host = localhost
[wanxiaod4]
user = root
password = *****
host = 192.168.1.3
wxd@wangxiaodong:~$
```

* 除了使用mysql_config_editor的方式配置登录选项外，也可以直接在宿主目录下创建.my.cnf文件，此时密码需要使用明文：
```
[client]
host=localhost
user='wxd'
password='123456'
```

---


### MySQL 分布式(XA)事务
* 分布式事务将存储引擎级别的ACID扩展到数据库层面，甚至扩展到多个数据库之间--这需要通过[二阶段提交](https://en.wikipedia.org/wiki/Two-phase_commit_protocol)实现
* 分布式事务需要具备一个或多个资源管理器(Resource Manager(RM))和一个事务管理器(Transaction Manager(TM))
* MySQL innoDB支持XA事务

  ```
  mysql> select * from my_xa_table;
  Empty set (0.00 sec)
  
  mysql> xa start 'myxa1';
  Query OK, 0 rows affected (0.00 sec)
  
  mysql> insert into my_xa_table values (1,'xa1');
  Query OK, 1 row affected (0.01 sec)
  
  mysql> xa end 'myxa1';
  Query OK, 0 rows affected (0.00 sec)
  
  mysql> xa prepare 'myxa1';
  Query OK, 0 rows affected (0.04 sec)
  
  mysql> xa commit 'myxa1';
  Query OK, 0 rows affected (0.04 sec)
  
  mysql> select * from my_xa_table;
  +----+-------+
  | id | value |
  +----+-------+
  |  1 | xa1   |
  +----+-------+
  1 row in set (0.00 sec)
  ```

### 常见问题
* MySQL修改端口后启动失败，报permission denied: 需要执行以下命令：
```
semanage port -a -t mysqld_port_t -p tcp 13306
```

### 2. Oracle
* 常规方式安装
* Docker方式安装


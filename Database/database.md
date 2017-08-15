# [王孝东的个人空间](https://scm-git.github.io/)
## Database
### 1. MySQL
* 常规方式安装
* Docker方式安装

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
* `SHOW GLOBAL STATUS`
* `SHOW PROCESSLIST`，在末尾加上\G可以垂直的方式输出结果，方便结合linux命令排序
* `mysql -e 'SHOW PROCESS LIST\G' | grep State: | sort | uniq -c | sort -rn`
* 慢查询日志，默认路径：/var/log/mysql/slow-query.log

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

### MySQL索引
* MySQL索引类型：
  * B-Tree：如果不特别指明，通常所说的索引就是B-Tree索引。节点会保存子节点的指针；使用B-Tree需要注意的地方：
    * 创建多列索引时一定要注意列顺序。
    * 如果不按照索引的最左列开始查找，则无法使用索引，例如一个索引：Key(LAST_NAME,FIRST_NAME,AGE)，如果WHERE字句中直接查找FIRST_NAME，则无法使用索引
    * 不能跳过索引中的列，也就是无法通过索引直接查找LAST_NAME=XXX AND AGE=XX
    * 如果查询中某个列有范围查询，则后边的列无法再使用索引优化查询
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
* 索引可以减少锁定的行，

### 优化查询
* **切分查询**，将一个大量数据的SQL操作切分为多个小量数据的SQL操作；如果用一个大的SQL语句一次性完成的话，可能需要一次性锁住很多数据，占满整个事务日志，耗尽系统资源，阻塞其他小的但很重要的查询
* **分解关联查询**，有如下好处：
  * 让缓存的效率更高
  * 将查询分解后，执行单个查询可以减少锁的竞争
  * 在应用层做关联，可以更容易对数据库进行拆分，更容易做到高性能和可扩展
  * 查询本身效率也可能得到提升
  * 可以减少冗余记录的查询
* 对于一个MySQL连接，或者说一个线程，任何时刻都有一个状态，该状态表示了MySQL当前正在做什么，可以通过`SHOW FULL PROCESSLIST`查询每个连接的状态，这些状态的意义如下：
  * Sleep
  * Query
  * Locked
  * Analyzing and statistics
  * Copying to tmp table [on disk]
  * Sorting result
  * Sending data

### 2. Oracle
* 常规方式安装
* Docker方式安装


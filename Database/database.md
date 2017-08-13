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
* 使用SHOW PROFILE；默认是关闭的，开启profile，在MySQL连接会话中执行`set profiling = 1;`，主要命令`show profiles`，`show profile on query 2`，示例如下：
  
  ```
  mysql> show profiles;
  +----------+------------+------------------------------------------------+
  | Query_ID | Duration   | Query                                          |
  +----------+------------+------------------------------------------------+
  |        1 | 0.00094075 | select * from printer order by id desc limit 5 |
  |        2 | 0.01456450 | select * from printer                          |
  +----------+------------+------------------------------------------------+
  2 rows in set, 1 warning (0.00 sec)
  
  mysql> show profile for query 2;
  +----------------------+----------+
  | Status               | Duration |
  +----------------------+----------+
  | starting             | 0.000125 |
  | checking permissions | 0.000039 |
  | Opening tables       | 0.000049 |
  | init                 | 0.000055 |
  | System lock          | 0.000041 |
  | optimizing           | 0.000036 |
  | statistics           | 0.000045 |
  | preparing            | 0.000042 |
  | executing            | 0.000036 |
  | Sending data         | 0.013845 |
  | end                  | 0.000042 |
  | query end            | 0.000052 |
  | closing tables       | 0.000041 |
  | freeing items        | 0.000079 |
  | cleaning up          | 0.000040 |
  +----------------------+----------+
  15 rows in set, 1 warning (0.00 sec)
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

* `SHOW GLOBAL STATUS`
* `SHOW PROCESSLIST`，在末尾加上\G可以垂直的方式输出结果，方便结合linux命令排序
* `mysql -e 'SHOW PROCESS LIST\G' | grep State: | sort | uniq -c | sort -rn`
* 慢查询日志，默认路径：/var/log/mysql/slow-query.log

### 2. Oracle
* 常规方式安装
* Docker方式安装


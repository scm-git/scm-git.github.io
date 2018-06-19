# [王孝东的个人空间](https://scm-git.github.io/)
## Neo4j

### Install with Stable Yum Repo
* import key
  ```
  cd /tmp
  wget http://debian.neo4j.org/neotechnology.gpg.key
  rpm --import neotechnology.gpg.key
  ```
  
* add neo4j yum repo: `/etc/yum.repos.d/neo4j.repo`
  ```
  cat <<EOF>  /etc/yum.repos.d/neo4j.repo
  [neo4j]
  name=Neo4j Yum Repo
  baseurl=http://yum.neo4j.org/stable
  enabled=1
  gpgcheck=1
  EOF
  ```
  
* install
  ```
  yum install neo4j
  ```
  
* 修改初始密码
  ```bash
  curl -H "Content-Type: application/json" -X POST -d '{"password":"newPassword"}' -u neo4j:neo4j http://127.0.0.1:7474/user/neo4j/password
  ```

* neo4j-shell

  设置如下配置项：
  ```
  dbms.shell.enabled=true
  ```
  说明： 目前只能在本机上通过neo4j-shell连接，远程连接始终是失败的,即使设置了dbms.shell.host=0.0.0.0也不能远程连接，没找到原因
  
  **neo4j-shell常用命令：**
  ```
  neo4j-sh (?)$ CREATE (wxd1:Person{name:'wxd1'}),(wxd2:Person{name:'wxd2'}), (wxd3:Person{name:'wxd3'}),(wxd1)-[:FRIEND]->(wxd2),(wxd2)-[:FRIEND]->(wxd3);
  +-------------------+
  | No data returned. |
  +-------------------+
  Nodes created: 3
  Relationships created: 2
  Properties set: 3
  Labels added: 3
  418 ms
  neo4j-sh (?)$ match(p:Person) return p;
  +-------------------------+
  | p                       |
  +-------------------------+
  | Node[1128]{name:"wxd1"} |
  | Node[1129]{name:"wxd2"} |
  | Node[1130]{name:"wxd3"} |
  +-------------------------+
  3 rows
  70 ms
  neo4j-sh (?)$ match (p:Person{name:'wxd1'})-[:FRIEND]-()-[:FRIEND]-(fof) return fof;
  +-------------------------+
  | fof                     |
  +-------------------------+
  | Node[1130]{name:"wxd3"} |
  +-------------------------+
  1 row
  233 ms
  一次match，只是将f重新提出来再做一次查询，一个模式的两条路径，容易和两个match的情况混淆
  neo4j-sh (?)$ match (p:Person{name:'wxd1'})-[:FRIEND]-(f), (f)-[:FRIEND]-(f2) return f2;
  +-------------------------+
  | f2                      |
  +-------------------------+
  | Node[1130]{name:"wxd3"} |
  +-------------------------+
  1 row
  108 ms
  
  
  无方向的关系查询，可以查询出wxd2的两个朋友：wxd1->wxd2->wxd3
  neo4j-sh (?)$ match (p:Person{name:'wxd2'})-[:FRIEND]-(f1) return f1;
  +-------------------------+
  | f1                      |
  +-------------------------+
  | Node[1130]{name:"wxd3"} |
  | Node[1128]{name:"wxd1"} |
  +-------------------------+
  2 rows
  31 ms
  
  有方向的关系，只能查询一个朋友：
  neo4j-sh (?)$ match (p:Person{name:'wxd2'})-[:FRIEND]->(f1) return f1;
  +-------------------------+
  | f1                      |
  +-------------------------+
  | Node[1130]{name:"wxd3"} |
  +-------------------------+
  
  注意这个查询的结果是两个朋友：match (p:Person{name:'wxd1'})-[:FRIEND]-(f1) match (f1)-[:FRIEND]-(f2) return f2;
  因为第二个match查询了f1(wxd1的朋友)的两个方向的朋友关系，两个match语句,因此是两个不同的模式
  neo4j-sh (?)$ match (p:Person{name:'wxd1'})-[:FRIEND]-(f1)
  > match (f1)-[:FRIEND]-(f2)
  > return f2;
  +-------------------------+
  | f2                      |
  +-------------------------+
  | Node[1130]{name:"wxd3"} |
  | Node[1128]{name:"wxd1"} |
  +-------------------------+
  2 rows
  63 ms
  neo4j-sh (?)$
  
  
  
  
  //可以有多个标签，但是只能有一个标签有属性                             ^
  neo4j-sh (?)$ create (u:User:Player{id:'player2'});
  +-------------------+
  | No data returned. |
  +-------------------+
  Nodes created: 1
  Properties set: 1
  Labels added: 2
  9 ms
  neo4j-sh (?)$ match (n:User:Player) return n;
  +--------------------------+
  | n                        |
  +--------------------------+
  | Node[1148]{}             |
  | Node[1149]{id:"player2"} |
  | Node[1168]{id:"player1"} |
  +--------------------------+
  3 rows
  46 ms
  
  //两个标签都加上属性，报错！
  neo4j-sh (?)$ create (u:User{name:'user1'}:Player{id:'player1'});
  3 ms
  
  WARNING: Invalid input ':': expected whitespace, ')' or a relationship pattern (line 1, column 29 (offset: 28))
  "create (u:User{name:'user1'}:Player{id:'player1'})"
  
  // CASE WHEN 语法：
  // CASE 
  // WHEN predicate THEN result1
  // [WHEN predicate THEN result2]
  // [ELSE default]
  // END [AS column_name] 
  neo4j-sh (?)$ match (b:Book) return b.title,case when b.price > 30 then 'high' when b.price <=30 then 'low' else 'middle' end as price;
  +------------------+
  | b.title | price  |
  +------------------+
  | "Neo4j" | "low"  |
  | "Java"  | "high" |
  +------------------+
  2 rows
  34 ms
  neo4j-sh (?)$
  
  // match 查询
  neo4j-sh (?)$ match (p:Person{name:'wxd2'})-->(f) return p,f;
  +---------------------------------------------------+
  | p                       | f                       |
  +---------------------------------------------------+
  | Node[1129]{name:"wxd2"} | Node[1130]{name:"wxd3"} |
  +---------------------------------------------------+
  1 row
  39 ms
  neo4j-sh (?)$ match (p:Person{name:'wxd2'})--(f) return p,f;
  +---------------------------------------------------+
  | p                       | f                       |
  +---------------------------------------------------+
  | Node[1129]{name:"wxd2"} | Node[1130]{name:"wxd3"} |
  | Node[1129]{name:"wxd2"} | Node[1128]{name:"wxd1"} |
  +---------------------------------------------------+
  2 rows
  41 ms
  
  // 查询关系:type(r)
  neo4j-sh (?)$ match (p:Person{name:'wxd2'})-[r]-(f) return p,type(r) as relation,f;
  +--------------------------------------------------------------+
  | p                       | type(r)  | f                       |
  +--------------------------------------------------------------+
  | Node[1129]{name:"wxd2"} | "FRIEND" | Node[1130]{name:"wxd3"} |
  | Node[1129]{name:"wxd2"} | "FRIEND" | Node[1128]{name:"wxd1"} |
  +--------------------------------------------------------------+
  2 rows
  58 ms
  
  //匹配关系类型，多种关系类型用竖线(|)隔开
  neo4j-sh (?)$ match (p:Person{name:'wxd2'})<-[:FRIEND]-(f) return p, f;
  +---------------------------------------------------+
  | p                       | f                       |
  +---------------------------------------------------+
  | Node[1129]{name:"wxd2"} | Node[1128]{name:"wxd1"} |
  +---------------------------------------------------+
  1 row
  36 ms
  neo4j-sh (?)$ match (p:Person{name:'wxd2'})<-[:FRIEND|:FAMILY]-(f) return p, f;
  +---------------------------------------------------+
  | p                       | f                       |
  +---------------------------------------------------+
  | Node[1129]{name:"wxd2"} | Node[1128]{name:"wxd1"} |
  +---------------------------------------------------+
  1 row
  47 ms
  
  // 对已存在的结点创建关系
  neo4j-sh (?)$ match (wxd1:Person{name:'wxd1'}), (wxd3:Person{name:'wxd3'}) create (wxd1)-[:`FRIEND`]->(wxd3);
  +-------------------+
  | No data returned. |
  +-------------------+
  Relationships created: 1
  86 ms
  
  // 删除节点及其所有关系
  neo4j-sh (?)$ match (p:Person{name:'wxd5'}) detach delete p;
  +-------------------+
  | No data returned. |
  +-------------------+
  Nodes deleted: 1
  Relationships deleted: 1
  43 ms
  
  // 只删除关系
  neo4j-sh (?)$ match (wxd1:Person{name:'wxd1'})-[r:`FRIEND`]->(wxd3:Person{name:'wxd3'}) DELETE r;
  +-------------------+
  | No data returned. |
  +-------------------+
  Relationships deleted: 1
  64 ms
  
  // 可变长关系：[:FRIEND*1..3]
  neo4j-sh (?)$ MATCH (p:Person{name:'wxd1'})-[:FRIEND*1..3]->(f) return p,f;
  +---------------------------------------------------+
  | p                       | f                       |
  +---------------------------------------------------+
  | Node[1128]{name:"wxd1"} | Node[1129]{name:"wxd2"} |
  | Node[1128]{name:"wxd1"} | Node[1130]{name:"wxd3"} |
  +---------------------------------------------------+
  2 rows
  67 ms
  
  // 增加属性值
  MATCH n WHERE Id(n)=14 SET n.name = 'wxd4'
  
  // id(node)获取内部的的结点ID，
  // 查询多个:
  match (node) id(node) in [1, 3,5]
  
  //删除label
  neo4j-sh (?)$ match (n) where id(n) = 1208 remove n:Person;
  +-------------------+
  | No data returned. |
  +-------------------+
  Labels removed: 1
  20 ms
  
  // 增加label
  neo4j-sh (?)$ match (n) where id(n) = 1208 set n:Person;
  +-------------------+
  | No data returned. |
  +-------------------+
  Labels added: 1
  
  // 不带标签查询结点： 
  neo4j-sh (?)$ match (n {id:'player1'}) return n;
  neo4j-sh (?)$ match (n {name:'wxd2'})-->() return n;
  +-------------------------+
  | n                       |
  +-------------------------+
  | Node[1129]{name:"wxd2"} |
  +-------------------------+
  1 row
  13 ms
  
  // 命名路径
  neo4j-sh (?)$ match p=(n:Person{name:'wxd1'})-->() return p;
  +------------------------------------------------------------------+
  | p                                                                |
  +------------------------------------------------------------------+
  | [Node[1128]{name:"wxd1"},:FRIEND[104]{},Node[1129]{name:"wxd2"}] |
  +------------------------------------------------------------------+
  1 row
  23 ms
  
  // id(relation)获取内部的关系ID
  neo4j-sh (?)$ match (a)-[r]-(b) where id(r)=104 return a,r,b;
  +--------------------------------------------------------------------+
  | a                       | r              | b                       |
  +--------------------------------------------------------------------+
  | Node[1128]{name:"wxd1"} | :FRIEND[104]{} | Node[1129]{name:"wxd2"} |
  | Node[1129]{name:"wxd2"} | :FRIEND[104]{} | Node[1128]{name:"wxd1"} |
  +--------------------------------------------------------------------+
  2 rows
  15 ms
  
  // =======================WHERE=======================
  //结点，关系的属性过滤
  neo4j-sh (?)$ match (n)-[r]-() where n.name = 'wxd1' and r.since = 1 return n,r;
  //属性存在性检查 exists(n.property)
  neo4j-sh (?)$ match (n)-[r]-() where exists(n.name) return n;
  
  // 字符串匹配： STARTS WITH, ENDS WITH, CONTAINS
  
  //正则表达式： =~
  (?i)不区分大小写，(?m)多行，(?s)单行
  
  // 关系过滤： type(r)
  neo4j-sh (?)$ match (n:Person)-[r]->() where type(r)='FRIEND' return n, r;
  +------------------------------------------+
  | n                       | r              |
  +------------------------------------------+
  | Node[1128]{name:"wxd1"} | :FRIEND[104]{} |
  | Node[1129]{name:"wxd2"} | :FRIEND[105]{} |
  +------------------------------------------+
  2 rows
  27 ms
  
  // 查询某个结点的label:
  neo4j-sh (?)$ match (n {id:'player1'}) return labels(n);
  +-------------------+
  | labels(n)         |
  +-------------------+
  | ["Player","User"] |
  +-------------------+
  1 row
  22 ms
  
  // 查询名为wxd1或者wxd6，且有一个关系的结点
  neo4j-sh (?)$ match (n) where n.name in ['wxd1','wxd6'] and (n)-[]-() return n;
  +-------------------------+
  | n                       |
  +-------------------------+
  | Node[1128]{name:"wxd1"} |
  +-------------------------+
  1 row
  42 ms
  // 等同于上一个查询
  neo4j-sh (?)$ match p=(n)-[]-() where n.name in ['wxd1','wxd6'] return n,p;
  +--------------------------------------------------------------------------------------------+
  | n                       | p                                                                |
  +--------------------------------------------------------------------------------------------+
  | Node[1128]{name:"wxd1"} | [Node[1128]{name:"wxd1"},:FRIEND[104]{},Node[1129]{name:"wxd2"}] |
  +--------------------------------------------------------------------------------------------+
  1 row
  24 ms
  
  //查询没有任何关系的结点:
  match (n) where not (n)-[]-() return n;
  
  //查询没有某种关系的结点：
  match (n:MachineRoom) where not (n)<-[]-(:IDC) return n;
  
  //创建索引：
  CREATE INDEX ON :Person(firstname);
  CREATE INDEX ON :Person(firstname, surname);
  
  // 删除索引：
  DROP INDEX ON :Person(firstname);
  DROP INDEX ON :Person(firstname, surname);
  
  // 查看索引：
  CALL db.indexes;
  
  // 创建unique约束：
  CREATE CONSTRAINT ON (book:Book) ASSERT book.isbn IS UNIQUE;
  
  // 删除unique约束
  DROP CONSTRAINT ON (book:Book) ASSERT book.isbn IS UNIQUE;
  
  // 创建存在性约束
  CREATE CONSTRAINT ON (book:Book) ASSERT exists(book.isbn);
  
  // 删除存在性约束
  DROP CONSTRAINT ON (book:Book) ASSERT exists(book.isbn);
  
  // 创建KEY约束
  CREATE CONSTRAINT ON (n:Person) ASSERT (n.firstname, n.surname) IS NODE KEY;
  
  // 删除KEY约束
  DROP CONSTRAINT ON (n:Person) ASSERT (n.firstname, n.surname) IS NODE KEY;
  
  // 创建关系属性存在性约束
  CREATE CONSTRAINT ON ()-[like:LIKED]-() ASSERT exists(like.day);
  
  // 删除关系属性存在性约束
  DROP CONSTRAINT ON ()-[like:LIKED]-() ASSERT exists(like.day);
  
  // 查看约束
  CALL db.constraints;
  ```
  
* cypher-shell cypher-shell是新版本的Neo4j支持的客户端工具，用于替换neo4j-shell，因此用法与neo4j-shell类似

  ```
  #需要打开该配置项：
  #dbms.connectors.default_listen_address=0.0.0.0
  #使用如下命令打开客户端：
  cypher-shell -a bolt://192.168.163.131:7687 -u neo4j -p 123456
  ```
  

* Neo4j备份
  1. 备份脚本如下： `neo4j_backup.sh`
     ```bash
     #!/bin/bash
  
     TIME=`date '+%Y%m%d%H%M%S'`
     BACKUP_DIR='/home/wxd/App/neo4j/neo4j_backup/'
     CURRENT_DIR=${BACKUP_DIR}${TIME}
  
     NEO4J_HOME='/home/wxd/App/neo4j/neo4j-enterprise-3.3.1'
  
     if [ ! -d "${CURRENT_DIR}" ]; then
       mkdir -p ${BACKUP_DIR}${TIME}
     fi
  
     echo "begin backup neo4j..."
     /home/finance/App/neo4j/neo4j-enterprise-3.3.1/bin/neo4j-admin backup --backup-dir=${CURRENT_DIR} --name=graph.db-backup --fallback-to-full=true
     echo "end backup neo4j..."
  ```
  
  2. 再配置crontab任务：
     ```bash
     $ crontab -e
     0 23 * * * /home/wxd/Shell/neo4j/neo4j_backup.sh
     ```
  
* Neo4j恢复
  1. 停止Neo4j数据库
  2. 执行恢复
  3. 启动
  ```bash
  $ neo4j stop
  $ neo4j-admin restore --from=/home/wxd/neo4j_backup/graph.db-backup --force
  $ neo4j start
  ```
  说明：--force选项表示覆盖原来的数据
  
### Neo4j常见问题
* [Spring Data Neo4j结点关系消失问题](./relation_missiong.md) 
* [Spring Data Neo4j缓存问题](./spring_data_neo4j_cache.md)
* [Spring Data Neo4j查询关系的深度问题](./spring_data_neo4j_depth.md)
* [Spring Data Neo4j @QueryResult 包问题]
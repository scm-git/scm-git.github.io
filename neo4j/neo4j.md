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
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
  curl -H "Content-Type: application/json" -X POST -d '{"password":"Neo4j@@123"}' -u neo4j:neo4j http://127.0.0.1:7474/user/neo4j/password
  ```
  
### Neo4j常见问题
* [Spring Data Neo4j结点关系消失问题](./relation_missiong.md) 
* [Spring Data Neo4j缓存问题](./spring_data_neo4j_cache.md)
* [Spring Data Neo4j查询关系的深度问题](./spring_data_neo4j_depth.md)
* [Spring Data Neo4j @QueryResult 包问题]
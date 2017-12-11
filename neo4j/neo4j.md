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
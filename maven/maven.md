# [王孝东的个人空间](https://scm-git.github.io/)
## Maven
### 常见问题
* 1.删错某个pom文件的所有依赖包：当下载依赖包出问题时，尤其是公司网络没有配置代理时下载jar出错，而maven又不能自动重新下载有效jar包时，可以用以下命令清除后重新下载，避免一个一个的手动删除：
  ```bash
  mvn dependency:purge-local-repository -DreResolve=false
  ```
  

# [王孝东的个人空间](https://scm-git.github.io/)
## Node.js

### Node.js高并发问题：
* [Node.js高并发配置](http://www.goorockey.com/2014/07/20/high-concurrency-setting-for-nodejs/)
* [Does NodeJS have a socket per connection, even though it is single threaded?](http://appcrawler.com/wordpress/2017/03/29/does-nodejs-have-a-socket-per-connection-even-though-it-is-single-threaded/)

### npm设置代理
```
# 查看配置
$ npm config ls -l
# 设置代理
$ npm config set proxy=http://localhost:7072
$ npm config set https_proxy=http://localhost:7072
# 设置代理后，npm会在~/.npmrc文件中生成配置项：
$ cat ~/.npmrc
proxy=http://localhost:7072/
https_proxy=http://localhost:7072

# 安装gulp，有时会安装失败；可能是因为网络原因
$ npm install -g gulp

# npm安装依赖失败：npm ERR! code EINTEGRITY
# 按如下说明操作：
# https://stackoverflow.com/questions/47545940/when-i-run-npm-install-it-returns-with-err-code-eintegrity-npm-5-3-0/53344301
$ npm cache verify
$ npm cache clean --force
# 上次是执行以下命令后生效的：
$ npm config set package-lock false

```
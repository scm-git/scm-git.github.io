# [王孝东的个人空间](https://scm-git.github.io/)
## GoLang

### 交叉编译
Windows:
```
Windows -> linux/mac
C:\Users\Administrator> set CGO_ENALBED=0
C:\Users\Administrator> set GOOS=linux  # linux
C:\Users\Administrator> set GOOS=darwin  # mac
C:\Users\Administrator> set GOARCH=amd64
C:\Users\Administrator> go build -o xxx
```

Mac:
```
# 不可换行
$ CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o xxx
$ CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build 0o xxx.exe
```

Linux:
```
$ CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o xxx
$ CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o xxx.exe
```

### 使用gopm解决go get下载gopkg.in包失败解决
1. 安装gopm
   ```
   $ go get -u github.com/gpmgo/gopm
   ```

2. 查看GOBIN($GO_HOME/bin)是否在PATH路径中，如果没有，则添加

3. 使用gopm get -g代替go get
   ```
   $ gopm get -u gopkg.in/go-playground/validator.v8
   ```

4. gopm下载完成之后，默认仓库为~/.gopm/repos路径下，可以将下载的包复制到$GO_HOME/src下

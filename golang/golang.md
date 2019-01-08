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
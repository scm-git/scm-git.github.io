# [王孝东的个人空间](https://scm-git.github.io/)
## Git
### Install git on Ubuntu
```
$ sudo apt-get install git
```
### [廖雪峰的git教程](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)
* 看这个教程足够了，其他不常用的git命令，用到的时候再查吧，反正长时间不用也会忘
* 配置git

  ```
  $ git config --global user.email "wang_0120@163.com"
  $ git config --global user.name "Wang Xiaodong"
  ```

* 有了git之后，你可以对你本地任何配置文件都用git管理起来。开发人员经常会遇到这样一个情况：当你在本地安装好需要的服务(例如MySQL, RabbitMQ, Redis, ELK等)，安装好之后你可能需要取修改它们的配置文件以满足自己的需求，但是修改时又会担心修改错了，导致服务无法启动，或者配置需要满足不同情况。这个时候你就可以直接用git把配置文件放入版本库。你只需要在配置文件目录中使用`git init`即可完成git仓库创建操作，然后将原始配置提交，后续如果想要回滚到原始配置或者某个特定版本就可以使用git来完成了～～

## GitHub
* 1.创建GitHub帐号:[https://github.com/](https://github.com/)
* 2.在本地生成ssh key，拷贝到GitHub中：

  ```
  $ ssh-keygen -t rsa -b 4096 -C "you email or other identifier"
  ```
  然后 一路回车。**如果你的机器上已经有密钥对，则可以直接使用现有的密钥**

* 3.将上一步生成的公钥(`~/.ssh/id_rsa.pub`)粘贴到GitHub中: `GitHub右上角的头像图标->settings->SSH and GPG keys`，然后点击`New SSH key`，写上标题，然后粘贴你的公钥内容，点击`Add SSH key`。

* 4.将你本地的仓库关联到GitHub远程仓库，注意关联自己的仓库，以下是我的仓库地址，我的仓库你可以关联，并且可以拉去，但是不能push修改

  ```
  $ git remote add origin git@github.com:scm-git/scm-git.github.io.git 
  ```
  **尽量使用ssh协议，如果使用https协议，可能每次推送时需要输入你的帐号密码，但是有些仓库无法使用ssh协议clone，但是通常可以使用https协议**
  
* 5.一些常用的命令

  ```
  $ git pull        # 拉取远程仓库的代码并merge到本地分支: git pull=git fetch + git merge
  $ git branch -a       #查看本地和远程仓库中的分支，当前所在仓库前面有一个*
  $ git checkout master     #切换分支
  $ git checkout -b dev origin/dev      #创建本地分支dev，并将远程的dev分支拉取到本地
  $ git remote rm origin        #如果你想将远程仓库地址切换到新的地址，可能需要先删除原有的远程仓库地址
  $ git remote add origin git@gitee.com:w_xd/wephoto.git  #添加远程仓库
  $ git branch --set-upstream-to origin/master master       #重新设置了远程仓库之后，需要对原有本地分支关联到新的远程仓库分支
  $ git remote -v       #查看远程仓库
  $ git show commit-hast:filename   #查看某次提交的文件内容
  $ git clone svn http://192.168.1.100/svn/myproject    #将svn转换为git，后续操作时就可以不再需要svn
  $ git show $commitId      #查看某测提交的内容, $commitId是提交的hash code
  $ git co -- <file>        #抛弃工作区的修改
  $ git co .        #抛弃工作区的修改
  $ git stash       #将修改保存到暂存区
  $ git stash pop   #将暂存区的修改恢复到工作区
  $ git stash  list/show    显示暂存区
  $ git reset -- <file>     #从暂存区恢复到工作文件
  $ git reset -- .              #从暂存区恢复到工作文件
  $ git rest --hard         #恢复最近一次提交过的状态
  $ git checkout -- <file>       #删除某各文件的所有修改，慎用此操作
  $ git checkout -- .       #删除所有修改，慎用此操作，需要确保所有的修改都需要丢弃时才使用
  $ git log -- path/to/folder   #查看某个目录下的commit日志
  $ git log -- path/to/folder/* #查看某个目录下的commit日志
  $ git tag -l      #查看所有tag
  $ git tag --help      #查看git tag帮助
  $ git tag v1.0        #创建一个tag，名为v1.0
  $ git push origin v1.0    #将tag v1.0推送到server
  $ git merge dev-1         #将dev-1分支合并到当前所在分支，比如当前在master分支，该命令合并dev-1分支到master分支
  ```
  [Git常用命令](http://www.cnblogs.com/cspku/articles/Git_cmds.html)
  
## 遇到的奇怪问题
今天在使用git提交的时候，出现下面的错误，不知道是什么原因:
```
wxd@wangxiaodong:~/main/repo_github/scm-git.github.io$ git add .
error: insufficient permission for adding an object to repository database .git/objects
error: websocket/websocket.md: failed to insert into database
error: unable to index file websocket/websocket.md
fatal: 添加文件失败
wxd@wangxiaodong:~/main/repo_github/scm-git.github.io$ git add websocket/websocket.md 
error: insufficient permission for adding an object to repository database .git/objects
error: websocket/websocket.md: failed to insert into database
error: unable to index file websocket/websocket.md
fatal: 添加文件失败
wxd@wangxiaodong:
```
后来通过将websocket.md改为websocket2.md后就可以顺利提交了，提交后又将名字改回来，就可以了，不知道为什么：
```
wxd@wangxiaodong:~/main/repo_github/scm-git.github.io$ git status
位于分支 master
您的分支与上游分支 'origin/master' 一致。
要提交的变更：
  （使用 "git reset HEAD <file>..." 撤出暂存区）

        修改：     README.md
        重命名：   websocket/websocket2.md -> websocket/websocket.md

wxd@wangxiaodong:~/main/repo_github/scm-git.github.io$ git commit -m "update websocket"
[master a638499] update websocket
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename websocket/{websocket2.md => websocket.md} (100%)
wxd@wangxiaodong:~/main/repo_github/scm-git.github.io$
```
  
# [王孝东的个人空间](https://scm-git.github.io/)
## Nginx

### Redhat/CentOS 安装Nginx
1. 添加nginx yum repository
   * 首先查看系统版本
     ```bash
      # lsb_release -a  #如果该命令不可用，可使用下面的方式
      # cat /etc/*-release
     ```
     实际命令如下：
     ```bash
     [ec2-user@ip-10-0-0-28 ~]$ lsb_release -a
     -bash: lsb_release: command not found
     [ec2-user@ip-10-0-0-28 ~]$ cat /etc/*-release
     NAME="Red Hat Enterprise Linux Server"
     VERSION="7.3 (Maipo)"
     ID="rhel"
     ID_LIKE="fedora"
     VERSION_ID="7.3"
     PRETTY_NAME="Red Hat Enterprise Linux Server 7.3 (Maipo)"
     ANSI_COLOR="0;31"
     CPE_NAME="cpe:/o:redhat:enterprise_linux:7.3:GA:server"
     HOME_URL="https://www.redhat.com/"
     BUG_REPORT_URL="https://bugzilla.redhat.com/"
     
     REDHAT_BUGZILLA_PRODUCT="Red Hat Enterprise Linux 7"
     REDHAT_BUGZILLA_PRODUCT_VERSION=7.3
     REDHAT_SUPPORT_PRODUCT="Red Hat Enterprise Linux"
     REDHAT_SUPPORT_PRODUCT_VERSION="7.3"
     Red Hat Enterprise Linux Server release 7.3 (Maipo)
     Red Hat Enterprise Linux Server release 7.3 (Maipo)
     [ec2-user@ip-10-0-0-28 ~]$
     ```
   
   * 添加 yum repo；在/etc/yum.repo.d目录下创建nginx.repo文件，内容如下:
     ```bash
     [nginx]
     name=nginx repo
     baseurl=http://nginx.org/packages/OS/OSRELEASE/$basearch/
     gpgcheck=0
     enabled=1
     ```
     内容中的OS，和OSRELEASE需要根据Linux系统及版本替换为相应的值：
     * OS:
       * Red Hat --> rhel
       * CentOS --> centos
     * OSRELEASE: 
       * 5.X --> 5
       * 6.X --> 6
       * 7.X --> 7

   * 通过上一步查到的系统的版本，我的当前系统应该分别为"rhel", "7"，实际命令如下：
     ```bash
     [ec2-user@ip-10-0-0-28 ~]$ cd /etc/yum.repos.d/
     [ec2-user@ip-10-0-0-28 yum.repos.d]$ ll
     total 24
     -rw-r--r--. 1 root root  358 Oct 20 13:01 redhat.repo
     -rw-r--r--. 1 root root  607 Jan 12 05:35 redhat-rhui-client-config.repo
     -rw-r--r--. 1 root root 8679 Jan 12 05:35 redhat-rhui.repo
     -rw-r--r--. 1 root root   80 Jan 12 05:35 rhui-load-balancers.conf
     [ec2-user@ip-10-0-0-28 yum.repos.d]$ sudo vi nginx.repo
     [ec2-user@ip-10-0-0-28 yum.repos.d]$ ll
     total 28
     -rw-r--r--. 1 root root   97 Jan 12 23:32 nginx.repo
     -rw-r--r--. 1 root root  358 Oct 20 13:01 redhat.repo
     -rw-r--r--. 1 root root  607 Jan 12 05:35 redhat-rhui-client-config.repo
     -rw-r--r--. 1 root root 8679 Jan 12 05:35 redhat-rhui.repo
     -rw-r--r--. 1 root root   80 Jan 12 05:35 rhui-load-balancers.conf
     [ec2-user@ip-10-0-0-28 yum.repos.d]$ cat nginx.repo
     [nginx]
     name=nginx repo
     baseurl=http://nginx.org/packages/rhel/7/$basearch/
     gpgcheck=0
     enabled=1
     
     [ec2-user@ip-10-0-0-28 yum.repos.d]$
     ```
     
2. 安装Nginx，执行如下命令：
   ```bash
   $ sudo yum install nginx
   ```
   
3. 配置nginx，配置文件:`/etc/nginx/nginx.conf`,`/etc/nginx/conf.d/default.conf`;修改的地方主要在default.conf文件中:
   ```bash
   [ec2-user@ip-10-0-0-28 conf.d]$ ll
   total 4
   -rw-r--r--. 1 root root 1355 Jan 16 03:41 default.conf
   [ec2-user@ip-10-0-0-28 conf.d]$ cat default.conf
   upstream cloudwechat {
           server 10.0.0.7:8080;
   }
   
   server {
       listen       80;
       server_name  localhost;
   
       #charset koi8-r;
       #access_log  /var/log/nginx/log/host.access.log  main;
   
       location / {
           root   /usr/share/nginx/html;
           index  index.html index.htm;
       }
   
       location /noauth {
            proxy_pass http://cloudwechat/cloud-print-profile-wsapi/noauth;
       }
   
       location /authsec {
           proxy_pass http://cloudwechat/cloud-print-profile-wsapi/authsec;
       }
   
       #error_page  404              /404.html;
   
       # redirect server error pages to the static page /50x.html
       #
       error_page   500 502 503 504  /50x.html;
       location = /50x.html {
           root   /usr/share/nginx/html;
       }
   
   }
   
   [ec2-user@ip-10-0-0-28 conf.d]$
   ```
   
   主要涉及到3个指令：
   
   * `upstream`,该指令用于配置后端的服务器组，其语法为：
     ```bash
     upstream name { }
     ```
     name是自己指定的名称，方便在location中引用，本例目前只有一个后端服务器，花括号内部通过server指令来设置后端服务器，这里列出以下示例来说明更多的配置项
     
     ```bash
     upstream backend {
     	server 10.0.0.7:8080 weight=5;    #server1
     	server 10.0.0.8:9090;             #server2
     }
     ```
     "#"为注释部分，该示例配置了两个后端server，并且配置了不同的端口; 在第一个server上配置了weight=5的权重，第二个server没有配置weight属性，则默认为1。这个配置表示6次请求中，有5次会转到server1上，1次转到server2上
     
     ```bash
     upstream backend {
     	ip_hash;
     	server 10.0.0.7:8080;                       #server1
     	server 10.0.0.8:9090;                       #server2
     }
     ```
     该配置加了一个`ip_hash`指令，用于将某一客户端的多次请求转发到固定的server上；对于需要回话保持的需求非常有用
     
   * `location`, 该指令主要用于地址匹配
   * `proxy_pass`, 该指令用于指定被代理的服务器的地址，从本例中可以看出：cloudwechat就是upstream指令后的name，表示请求转发到cloudwechat的后端服务器组。

4. nginx启动：
   ```bash
   [ec2-user@ip-10-0-0-28 conf.d]$ nginx
   ```
   如果是root用户安装，可能只有root用户才有权限，则需要使用`sudo nginx`
   其他常用命令：
   * `nginx -s stop/quit/reload`
     * stop - 快速停止，不管是否有请求正在处理
   	 * quit - 优雅的停止：会等待所有正在处理的请求结束
     * reload - 重新加载配置：首先会检查nginx的配置是有语法错误，如果有错则不加载，如果没有错误，nginx与使用的新的配置启动新的工作进程，然后优雅的停止旧的工作进程。
   * `nginx -t`,只检查nginx配置是否正确，不执行任何操作；当你修改完配置文件后，可以首先执行该命令以确定配置文件是否有语法错误：
     ```bash
     [ec2-user@ip-10-0-0-28 ~]$ sudo nginx -t
     nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
     nginx: configuration file /etc/nginx/nginx.conf test is successful
     [ec2-user@ip-10-0-0-28 ~]$
     ```
     
5. Nginx 配置支持websocket;从WebSocket的相关文档来看Ngxinx对WebSocket的支持并不够好，因此推荐用[HAProxy](../haproxy/haproxy.md)

6. Nginx配置Basic Auth
   * 生成密码文件，位置随意，如：`/etc/nginx/passwd`,密码文件格式如下：
     ```bash
     username:password:comment
     ```
     password需要是有htpasswd或者openssl生成密文，例如：
     ```
     [ec2-user@ip-10-0-0-28 ~]$ openssl passwd -crypt 123456
     [ec2-user@ip-10-0-0-28 ~]$ yhny4zWwv/ZW6
     ```
     将输出的内容粘贴到密码文件中，内容如下：
     ```
     username:yhny4zWwv/ZW6:123456
     ```
     
   * 配置Nginx
     ```bash
     server{
     	...
     
             location /
             {
                     auth_basic "nginx basic http test for ttlsa.com";
                     auth_basic_user_file /etc/nginx/passwd; 
                     autoindex on;
             }
     	
     	...
     }
     ```
     
   * 重启nginx：(注意可能需要root帐号才有权限),先用`nginx -t`测试一下配置文件是否有语法错误，如果没有就可重启Nginx,`nginx -s reload`
     ```bash
     [root@ip-10-0-0-28 conf.d]# nginx -t
     nginx: [warn] duplicate MIME type "text/html" in /etc/nginx/conf.d/00_elastic_beanstalk_proxy.conf:45
     nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
     nginx: configuration file /etc/nginx/nginx.conf test is successful
     [root@ip-10-226-8-120 conf.d]# nginx -s reload
     ```

7. Nginx其他常用命令
   ```bash
   nginx -c /tmp/nginx.conf   #指定配置文件，否则会使用configure编译阶段指定的默认配置文件
   nginx -p /usr/local/nginx/   #指定安装目录
   nginx -g "pid /var/nginx/test.pid"   # -g指定全局配置项，全局配置项不能与默认配置项同时配置，否则会冲突，另外使用其他命令时也需同时指定已配置的全局配置项，例如：nginx -g "pid /var/nginx/test.pid" -s stop
   nginx -v   #查看版本信息
   nginx -V   #查看编译阶段的参数
   [root@bogon nginx]# nginx -V
   nginx version: nginx/1.12.2
   built by gcc 4.8.5 20150623 (Red Hat 4.8.5-16) (GCC)
   built with OpenSSL 1.0.2k-fips  26 Jan 2017
   TLS SNI support enabled
   configure arguments: --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie'
   ```

8. Nginx server_name配置详解
server_name配置nginx虚拟主机的名称，当请求进入到nginx时，nginx根据request header中的host来匹配server块中server_name，由此判定该请求由哪一个server块来处理，匹配规则如下：
  1. server_name能完全匹配host，则由完全匹配的server块处理
  2. 前通配符匹配host，如：host: test1.example.com, server_name *.example.com
  3. 后通配符匹配host，如：host: test1.example.com, server_name test.example.*
  4. 都无法匹配，则由listen配置项中有default_server的配置块处理，如： listen 8081 default_server
  5. 如果没有default_server配置项，nginx会选择配置中的第一个server块作为default_server，因此前4项都不满足时，会由第一个server块处理

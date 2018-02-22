# [王孝东的个人空间](https://scm-git.github.io/)
## squid + stunnel 搭建代理服务器
### 已搭建的服务器地址
`web-proxy.guoweizu.com:801/pac`

1. 国外服务器安装squid + stunnel，推荐使用AWS日本区域的服务器，经测试中国区ping日本区服务器的延迟较低：
2. 生成证书文件
3. 配置stunnel, /etc/stunnel/stunnel.conf路径(如果没有则创建该文件)
4. 国内服务器安装stunnel,同样修改配置/etc/stunnel/stunnel.conf
5. 将国外服务器上的/etc/stunnel/stunnel.pem上传到国内服务器的/etc/stunnel/目录下

  ```bash
  yum -y install squid stunnel
  openssl req -new -x509 -days 365 -nodes -out stunnel.pem -keyout /etc/stunnel/stunnel.pem
  useradd -s /sbin/nologin -M stunnel
  touch /etc/stunnel/stunnel.log
  ```

  国外服务器：/etc/stunnel/stunnel.conf 文件内容(直接复制粘贴)：
  ```
  cert=/etc/stunnel/stunnel.pem
  CAfile=/etc/stunnel/stunnel.pem
  socket=l:TCP_NODELAY=1
  socket=r:TCP_NODELAY=1
  
  ;;;chroot=/var/run/stunnel
  pid=/tmp/stunnel.pid
  verify=3
  
  ;;; CApath=certs
  ;;; CRLpath=crls
  ;;; CRLfile=crls.pem
  
  setuid=stunnel
  setgid=stunnel
  
  ;;; client=yes
  compression=zlib
  ;;; taskbar=no
  delay=no
  ;;; failover=rr
  ;;; failover=prio
  sslVersion=TLSv1
  ;;; fips=no
  
  debug=7
  syslog=no
  output=stunnel.log
  
  [sproxy]
  accept=34567
  connect=127.0.0.1:3128
  ```
  
  启动squid, stunnel
  ```bash
  squid
  stunnel
  ```
  如果没有错误输出则表示启动成功
  
  国内服务器：/etc/stunnel/stunnel.conf 文件内容(直接复制粘贴)：
  ```
  cert=/etc/stunnel/stunnel.pem
  socket=l:TCP_NODELAY=1
  socket=r:TCP_NODELAY=1
  verify=2
  CAfile=/etc/stunnel/stunnel.pem
  client=yes
  compression=zlib
  ciphers=AES256-SHA
  delay=no
  failover=prio
  sslVersion=TLSv1
  ;; fips=no
  [sproxy]
  accept =0.0.0.0:7071
  connect=国外服务器IP:34567
  ```
  将**国外服务器IP**修改为实际的机器IP
  启动stunnel
  ```bash
  stunnel
  ```
  
  浏览器代理配置：国内服务器IP:7071
  
  参考文章：
  [https://www.saintic.com/blog/95.html](https://www.saintic.com/blog/95.html)
  
  
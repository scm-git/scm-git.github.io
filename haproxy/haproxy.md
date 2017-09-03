# [王孝东的个人空间](https://scm-git.github.io/)
## HAProxy [官网](http://www.haproxy.org/)
### Install HAProxy on Ubuntu
```
$ sudo apt install haproxy
```

### HAProxy [文档](http://cbonte.github.io/haproxy-dconv/1.7/intro.html)

### HAProxy配置HTTP负载均衡以及日志配置
HAProxy使用Linux的rsyslog服务来记录日志，因此需要配置haproxy和rsyslog
1. 安装好haproxy后，修改`/etc/haproxy/haproxy.cfg`文件，内如容下：
  
  ```
  global
          #log /dev/log   local0
          #log /dev/log   local1 notice
          #chroot /var/lib/haproxy
          log 127.0.0.1 local3
  
          stats socket /run/haproxy/admin.sock mode 660 level admin
          stats timeout 30s
          user haproxy
          group haproxy
          daemon
  
          # Default SSL material locations
          ca-base /etc/ssl/certs
          crt-base /etc/ssl/private
  
          # Default ciphers to use on SSL-enabled listening sockets.
          # For more information, see ciphers(1SSL). This list is from:
          #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
          # An alternative list with additional directives can be obtained from
          #  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
          ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
          ssl-default-bind-options no-sslv3
  
  defaults
          mode http
          log global
          option httplog
          option  http-server-close
          option  dontlognull
          option  redispatch
          option  contstats
          retries 3
          backlog 10000
          timeout client          25s
          timeout connect          5s
          timeout server          25s
          # timeout tunnel available in ALOHA 5.5 or HAProxy 1.5-dev10 and higher
          timeout tunnel        3600s
          timeout http-keep-alive  1s
          timeout http-request    15s
          timeout queue           30s
          timeout tarpit          60s
          default-server inter 3s rise 2 fall 3
          option forwardfor
  
          errorfile 400 /etc/haproxy/errors/400.http
          errorfile 403 /etc/haproxy/errors/403.http
          errorfile 408 /etc/haproxy/errors/408.http
          errorfile 500 /etc/haproxy/errors/500.http
          errorfile 502 /etc/haproxy/errors/502.http
          errorfile 503 /etc/haproxy/errors/503.http
          errorfile 504 /etc/haproxy/errors/504.http
  
  frontend ft_web
          option httplog
          log /dev/log local3 info
          bind *:7000 name http
          maxconn 10000
          default_backend bk_web
   
  backend bk_web                      
          balance hdr(tableId)
          server websrv1 localhost:7070 maxconn 10000 weight 10 cookie websrv1 check
          server websrv2 localhost:7071 maxconn 10000 weight 10 cookie websrv2 check
  ```
  
2. 配置如果安装了haproxy，通常`/etc/rsyslog.d/`目录下会有一个*-haproxy.cfg的文件，修改这个文件：
  
  ```
  # Create an additional socket in haproxy's chroot in order to allow logging via
  # /dev/log to chroot'ed HAProxy processes
  $AddUnixListenSocket /var/lib/haproxy/dev/log
  
  local3.*	/var/log/haproxy/haproxy.log
  
  # Send HAProxy messages to a dedicated logfile
  if $programname startswith 'haproxy' then /var/log/haproxy/haproxy.log
  &~
  ```
  
3. 重启haproxy和rsyslog

  ```
  $ sudo service haproxy restart
  $ sudo service rsyslog restart
  ```

### 配置HAProxy作为WebSocket的负载均衡器以及后端路由介绍
HAProxy配置WebSocket负载均衡，
**WebSocket无法设置请求header，因此如果想通过header的某个参数来来做路由是不可行的；便可以使用将参数放入url中，通过url_param来获取**

  ```
  global
  	#log /dev/log	local0
  	#log /dev/log	local1 notice
  	#chroot /var/lib/haproxy
  	log 127.0.0.1 local3 info
  
  	stats socket /run/haproxy/admin.sock mode 660 level admin
  	stats timeout 30s
  	user haproxy
  	group haproxy
  	daemon
  
  	# Default SSL material locations
  	ca-base /etc/ssl/certs
  	crt-base /etc/ssl/private
  
  	# Default ciphers to use on SSL-enabled listening sockets.
  	# For more information, see ciphers(1SSL). This list is from:
  	#  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
  	# An alternative list with additional directives can be obtained from
  	#  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
  	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
  	ssl-default-bind-options no-sslv3
  
  defaults
  	mode http
  	log global
  	option httplog
  	option  http-server-close
  	option  dontlognull
  	option  redispatch
  	option  contstats
  	retries 3
  	backlog 10000
  	timeout client          25s
  	timeout connect          5s
  	timeout server          25s
  	# timeout tunnel available in ALOHA 5.5 or HAProxy 1.5-dev10 and higher
  	timeout tunnel        3600s
  	timeout http-keep-alive  1s
  	timeout http-request    15s
  	timeout queue           30s
  	timeout tarpit          60s
  	default-server inter 3s rise 2 fall 3
  	option forwardfor
  
  	errorfile 400 /etc/haproxy/errors/400.http
  	errorfile 403 /etc/haproxy/errors/403.http
  	errorfile 408 /etc/haproxy/errors/408.http
  	errorfile 500 /etc/haproxy/errors/500.http
  	errorfile 502 /etc/haproxy/errors/502.http
  	errorfile 503 /etc/haproxy/errors/503.http
  	errorfile 504 /etc/haproxy/errors/504.http
  
  frontend ft_web
  	option httplog
  	capture request header Host len 15
  	log /dev/log local3 debug
  	bind *:7000 name http
  	maxconn 60000
  
  	## routing based on Host header
  	#acl host_ws hdr_beg(Host) -i ws.
  	#use_backend bk_ws if host_ws
  
  	## routing based on websocket protocol header
  	#acl hdr_connection_upgrade hdr(Connection)  -i upgrade
  	#acl hdr_upgrade_websocket  hdr(Upgrade)     -i websocket
  
  	capture request header Sec-WebSocket-Key len 40 
  
  	#use_backend bk_ws if hdr_connection_upgrade hdr_upgrade_websocket
  
  	default_backend bk_web
   
  backend bk_web                      
  	balance url_param tableId 
  	server websrv1 localhost:7070 maxconn 10000 weight 10 cookie websrv1 check
  	server websrv2 localhost:7071 maxconn 10000 weight 10 cookie websrv2 check
  
  backend bk_ws
  	balance url_param tableId 
  	 
  	## websocket protocol validation
  	acl hdr_connection_upgrade hdr(Connection)                 -i upgrade
  	acl hdr_upgrade_websocket  hdr(Upgrade)                    -i websocket
  	acl hdr_websocket_key      hdr_cnt(Sec-WebSocket-Key)      eq 1
  	acl hdr_websocket_version  hdr_cnt(Sec-WebSocket-Version)  eq 1
  	http-request deny if ! hdr_connection_upgrade ! hdr_upgrade_websocket ! hdr_websocket_key ! hdr_websocket_version
  
  	## ensure our application protocol name is valid 
  	## (don't forget to update the list each time you publish new applications)
  	acl ws_valid_protocol hdr(Sec-WebSocket-Protocol) echo-protocol
  	http-request deny if ! ws_valid_protocol
  
  	## websocket health checking
  	#option httpchk GET / HTTP/1.1rnConnection:\ Upgrade\r\nUpgrade:\ websocket\r\nSec-WebSocket-Key:\ haproxy\r\nSec-WebSocket-Version:\ 13\r\nSec-WebSocket-Protocol:\ echo-protocol
  	#http-check expect status 101
  
  	server websrv1 localhost:7070 maxconn 30000 weight 10 cookie websrv1 check
  	server websrv2 localhost:7071 maxconn 30000 weight 10 cookie websrv2 check
  ```
# [王孝东的个人空间](https://scm-git.github.io/)

## Tenable 问题
如果执行以下命令时发生 `409` 错误，则可以将/etc/tenable_tag删掉，再重新执行
```
sudo /opt/nessus_agent/sbin/nessuscli agent link --key=00abcd00000efgh11111i0k222lmopq3333st4455u66v777777w88xy9999zabc00 --name=MyOSXAgent --groups=your-env --host=securityserver.com--port=443 --name=your-hostname
```

[原文链接](https://docs.tenable.com/nessus/6_10/Content/UnixAgentInstall.htm)

查看nessusagent link状态
```
[ec2-user@ip-10-0-0-64 ~]$ sudo /opt/nessus_agent/sbin/nessuscli agent status
[info] [agent] Linked to cloud.tenable.com:443
[info] [agent] 0 jobs pending
[ec2-user@ip-10-0-0-64 ~]$
```

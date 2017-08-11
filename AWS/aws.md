# [王孝东的个人空间](https://scm-git.github.io/)
## AWS
### AWS 命令行配置
  以下三种方式选一即可:
1. 命令行选项  
  ```
  $ aws configure
  AWS Access Key ID [None]: Your AWS Access Key ID
  AWS Secret Access Key [None]: Your AWS Access Secret Key
  Default region name [None]: us-west-2
  Default output format [None]: json
  ```
2. 环境变量  
  ```
  $ export AWS_ACCESS_KEY_ID=Your AWS Access Key ID
  $ export AWS_SECRET_ACCESS_KEY=Your AWS Access Secret Key
  $ export AWS_DEFAULT_REGION=us-west-2
  ```
3. 使用credentials文件:
  ```
  [default]
  aws_access_key_id=Your AWS Access Key ID
  aws_secret_access_key=Your AWS Access Secret Key
  ```

### EC2
* 列出us-west-1中的所有EC2的名称和公有IP：
  ```
  $ aws ec2 describe-instances --query Reservations[*].Instances[*].[Tags[?Key=='Name'].Value,PublicIpAddress] --region us-west-1 --output table
  ```
* 列出us-west-1中的所有EC2的名称、公有IP、私有IP以及Access Key：
  ```
  $ aws ec2 describe-instances --query Reservations[*].Instances[*].[Tags[?Key=='Name'].Value,PublicIpAddress,PrivateIpAddress,KeyName] --region us-west-1 --output table
  ```
  
### VPC AZ Subnet CIDR
* CIDR：前缀IP必须是子网的最小IP，否则就是一个无效CIDR  
  有效： 10.0.0.0/24，无效：10.0.0.11/24
  有效： 10.0.0.192/26，无效：10.0.0.196/26
  计算的最小IP：2<sup>(8-x)</sup> * n；n为第n个子网，x是CIDR中落在网络段中的模
* 10.0.1.0/23 包括 10.0.0.0/24
  10.0.1.0/23
  00001100.00000000.00000001.00000000 起始IP：10.0.1.0
  11111111.11111111.11111110.00000000 子网掩码255.255.254.0
  10.0.3.0/23 
  10.0.1.193/26
  Must be a valid CIDR block. Did you mean 10.0.1.192/26?
* 同一个AZ中的主机间的ping速率为0.4ms; 不同AZ中的主机间的ping速率为1.2ms
* EC2之间无法ping通的原因通常是安全组中没有设置ICMP的入栈规则，因为ping命令使用的是ICMP协议
  


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
  ```$ aws ec2 describe-instances --query Reservations[*].Instances[*].[Tags[?Key=='Name'].Value,PublicIpAddress] --region us-west-1 --output table```
* 列出us-west-1中的所有EC2的名称、公有IP、私有IP以及Access Key：
  ```$ aws ec2 describe-instances --query Reservations[*].Instances[*].[Tags[?Key=='Name'].Value,PublicIpAddress,PrivateIpAddress,KeyName] --region us-west-1 --output table```

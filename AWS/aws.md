# [王孝东的个人空间](https://scm-git.github.io/)
## AWS
### EC2
* 列出us-west-1中的所有EC2的名称、公有IP、私有IP以及Access Key：
  
  `aws ec2 describe-instances --query Reservations[*].Instances[*].[Tags[?Key=='Name'].Value,PublicIpAddress] --region us-west-1 --output table`
* 列出us-west-1中的所有EC2的名称、公有IP、私有IP以及Access Key：
  
  `aws ec2 describe-instances --query Reservations[*].Instances[*].[Tags[?Key=='Name'].Value,PublicIpAddress,PrivateIpAddress,KeyName] --region us-west-1 --output table`

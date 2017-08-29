#!/bin/bash

case $1 in
	"ap-southeast-1")
		REGION="ap-southeast-1"
		;;
	*)
		REGION="us-west-1"
		;;
esac

echo "region:$REGION"

SGLIST=$(aws ec2 describe-security-groups --query 'SecurityGroups[*].{ID:GroupId}' --region $REGION --output text)
MYIP=$(curl -XGET "http://checkip.amazonaws.com")
MYCIDR=${MYIP}/32
echo "my CIDR: $MYCIDR"

for SG in $SGLIST
do
	echo "add ssh for $SG,$MYCIDR,$REGION"
	aws ec2 authorize-security-group-ingress --group-id $SG --protocol tcp --port 22 --cidr $MYCIDR --region $REGION
# 	aws ec2 revoke-security-group-ingress --group-id $SG --protocol tcp --port 22 --cidr $MYCIDR --region $REGION
done

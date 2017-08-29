#!/bin/bash

while [ "$1" ] ; do
    case "$1" in
        "-r" | "--region" )
            REGION="$2"
            shift 2
            ;;
        "--cidr" )
            CIDR="$2"
            shift 2
            ;;
        "-t" | "--type" )
            TYPE="$2"
            shift 2
            ;;
        *)
            echo "[ERROR] invalid command: $1"
            exit 1
            ;;
    esac
done

if [[ "$REGION" == "" ]]; then
    REGION="us-west-1"
fi

# if no cidr, set the current IP as default IP
if [[ "$CIDR" == "" ]]; then
    MYIP=$(curl -XGET "http://checkip.amazonaws.com")
    CIDR=${MYIP}/32
fi

echo "region: $REGION, my CIDR: $CIDR, type: $TYPE "

SGLIST=$(aws ec2 describe-security-groups --query 'SecurityGroups[*].{ID:GroupId}' --region $REGION --output text)
for SG in $SGLIST
do
    if [[ $TYPE == "authorize" ]]; then
	    echo "authorize ssh for $SG,$CIDR,$REGION"
	    #	aws ec2 authorize-security-group-ingress --group-id $SG --protocol tcp --port 22 --cidr $CIDR --region $REGION
	elif [[ $TYPE == "revoke" ]]; then
        echo "revoke ssh for $SG,$CIDR,$REGION"
        #	aws ec2 revoke-security-group-ingress --group-id $SG --protocol tcp --port 22 --cidr $CIDR --region $REGION
    else
        echo "invalid type: should be [authorize | revoke]"
        exit 1
     fi
done

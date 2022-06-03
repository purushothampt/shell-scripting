#! /bin/bash

if [ -z $1 ]; then
  echo -e '\e[31m Machine name is needed \e[0m'
  exit 1
fi

COMPONENT=$1
ZONE_ID="Z07728992EJSXZZKABHJD"

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=Allow_all_traffic | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')

PRIVATE_IP=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --count 1 \
  --instance-type t2.micro \
  --security-group-ids $SG_ID \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT}]" \
  --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
  | jq '.Instances[].PrivateIpAddress'| sed -e 's/"//g')

sed -e "s/COMPONENT/$COMPONENT/" -e "s/PRIVATE_IP/$PRIVATE_IP/" route53.json >/tmp/route53.json
aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch file:///tmp/route53. | jq



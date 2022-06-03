#! /bin/bash

if [ -z $1 ];then
  echo -e "\e[31m Input Machine name is needed \e[0m"
  exit 1
fi

COMPONENT=$1
ZONE_ID="Z07728992EJSXZZKABHJD"

create_ec2(){
  PRIVATE_IP=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type t2.micro \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT}]" \
    --security-group-ids $SGID \
    --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent ,InstanceInterruptionBehavior=stop}" \
    | jq '."Instances"[].PrivateIpAddress' | sed -e 's/"//g')
    sed -e "s/COMPONENT/$COMPONENT/" -e "s/PRIVATE_IP/$PRIVATE_IP/" route53.json >/tmp/record.json
    aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch file:///tmp/record.json | jq
}

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=Allow_all_traffic | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')

if [ $1 == 'all' ]; then
  for component in cart catalogue user shipping payment frontend rabbitmq redis mysql mongodb ; do
    COMPONENT=$component
    create_ec2
  done
else
    create_ec2
fi



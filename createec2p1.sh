#! /bin/bash

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=Allow_all_traffic | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g)'
echo $SG_ID
#aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type t2.micro --security-group-ids $SG_ID

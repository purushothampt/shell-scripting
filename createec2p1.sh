#! /bin/bash

AMI_ID=$(aws ec2 describe-images --owners amazon --filters "Name=name,Values=Centos-7-DevOps-Practice")
echo $AMI_ID
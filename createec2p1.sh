#! /bin/bash

aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq


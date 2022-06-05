PRIVATE_IP=$(aws ec2 describe-instances  --filters "Name=tag-value,Values=workstation" | jq '.Instances[].PrivateIpAddress')
echo $PRIVATE_IP

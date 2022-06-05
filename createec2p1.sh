PRIVATE_IP=$(aws ec2 describe-instances  --filters "Name=tag-value,Values=workstation" --query "Reservations[*].Instances[*].[PrivateIpAddress]")
echo $PRIVATE_IP


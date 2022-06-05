

PRIVATE_IP=$(aws ec2 describe-instances  --filters "Name=tag-value,Values=workstation" --query "Reservations[*].Instances[*].[PrivateIpAddress]" --output text)
AMI_ID=$(aws ec2 describe-images --filters "Name='name',Values=Centos-7-DevOps-Practice" --query "Images[*].[ImageId]" --output text)
SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=Allow_all_traffic" --query "SecurityGroups[*].[GroupId]" --output text)
aws route53 list-hosted-zones --output json



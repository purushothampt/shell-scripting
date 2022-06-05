

PRIVATE_IP=$(aws ec2 describe-instances  --filters "Name=tag-value,Values=workstation" --query "Reservations[*].Instances[*].[PrivateIpAddress]" --output text)
AMI_ID=$(aws ec2 describe-images --filters "Name='name',Values=Centos-7-DevOps-Practice" --query "Images[*].[ImageId]" --output text)





if [ -z $1 ]; then
  echo -e "\e[31m Input the Component Name\e[0m"
  exit 1
fi

LOG=/tmp/instance-create.log
rm -f $LOG

EC2_CREATE() {
  COMPONENT=$1
  AMI_ID=$(aws ec2 describe-images --filters "Name='name',Values=Centos-7-DevOps-Practice" --query "Images[*].[ImageId]" --output text)
  if [ -z "$AMI_ID" ];then
    echo -e "\e[31m unable to find the AMI \e[0m"
    exit 1
  else
    echo -e "\e[32mAMI ID = $AMI_ID\e[0m"
  fi

  PRIVATE_IP=$(aws ec2 describe-instances  --filters "Name=tag-value,Values=$COMPONENT" --query "Reservations[*].Instances[*].[PrivateIpAddress]" --output text)
  echo $PRIVATE_IP
  if [ -z "$PRIVATE_IP" && "$PRIVATE_IP" != 'None' ]; then
    #Find Security Group
    SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=Allow_all_traffic" --query "SecurityGroups[*].[GroupId]" --output text)
    if [ -z "$SG_ID" ]; then
      echo -e "\e[31m Security Group does not exist\e[0m"
      exit 1
    fi
    #creating EC2 Instance
    aws ec2 run-instances \
        --image-id $AMI_ID \
        --instance-type t3.micro \
        --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
        --security-group-ids $SG_ID \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT}]" "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=$COMPONENT}]" &>>$LOG
    echo -e "\e[1m Instance $COMPONENT Created \e[0m"
  else
    echo "Instance $COMPONENT Already exists, Hence new EC2 is not created"
  fi
  #create DNS Records
  ZONE_ID=$(aws route53 list-hosted-zones --query "HostedZones[*].{name:Name,ID:Id}" --output text | grep roboshop.internal | awk '{print $1}' | awk -F / '{print $3}')

  IP_ADDRESS=$(aws ec2 describe-instances  --filters "Name=tag-value,Values=$COMPONENT" --query "Reservations[*].Instances[*].[PrivateIpAddress]" --output text)

  echo '{
                "Comment": "CREATE/DELETE/UPSERT a record ",
                "Changes": [{
                "Action": "UPSERT",
                            "ResourceRecordSet": {
                                        "Name": "DNSNAME.roboshop.internal",
                                        "Type": "A",
                                        "TTL": 300,
                                     "ResourceRecords": [{ "Value": "IPADDRESS"}]
    }}]
    }' | sed -e "s/DNSNAME/$COMPONENT/" -e "s/IPADDRESS/$IP_ADDRESS/" >/tmp/route53.json

  aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch file:///tmp/route53.json --output text  &>>$LOG
  echo -e "\e[1m DNS Record for $COMPONENT Created \e[0m"

}

#main program

if [ $1 == 'list' ]; then
  aws ec2 describe-instances  --query "Reservations[*].Instances[*].{PrivateIP:PrivateIpAddress,PublicIP:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}"  --output table
  exit
elif [ $1 == 'All' ]; then
  for component in frontend catalogue cart mongodb user redis rabitmq payment mysql shipping ; do
    EC2_CREATE $component
  done
else
  EC2_CREATE $1
fi

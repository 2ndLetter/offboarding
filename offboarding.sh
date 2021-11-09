#!/bin/bash

## Notes: If possible, unique tags should be created for all applicable aws resources [Owner: jdoe]

USER=$1
ACCOUNT=$(aws sts get-caller-identity | jq -r ".Account")

# Release EIP(s)
function release_eip {
    EIP_ALLOCATION=$(aws ec2 describe-addresses --filters "Name=tag:Owner,Values=$USER" --query "[Addresses[*].AllocationId]" --output text)
    for i in $EIP_ALLOCATION
    do
      #aws ec2 release-address --allocation-id $i
      echo "EIP $i has been released"
    done
}

# Terminate developer ec2 instance(s)
function terminate_ec2 {
    INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=owner-id,Values=$ACCOUNT" "Name=tag:Owner,Values=$USER" --query "[Reservations[*].Instances[*].InstanceId]" --output text)
    for i in $INSTANCE_ID
    do
      #aws ec2 terminate-instances --instance-ids $INSTANCE_ID
      echo "ec2 Instance $i has been deleted"
    done    
}

# Delete ec2 keypair(s)
function delete_ec2_keypair {
    KEYPAIR=$(aws ec2 describe-key-pairs --filters "Name=tag:Owner,Values=$USER" --query "[KeyPairs[*].KeyName]" --output text)
    for i in $KEYPAIR
    do
      #aws ec2 delete-key-pair --key-name $i
      echo "KeyPair $i has been deleted"
    done
}

release_eip
terminate_ec2
delete_ec2_keypair 






# Revoke VPN certificate

# Delete MFA account

# Delete IAM user account

# Remove from windows account from jumpbox

# Remove IP address from Whitelists

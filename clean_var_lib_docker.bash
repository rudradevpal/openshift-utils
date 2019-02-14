vm_ip=$1
vm_user=$2
key_file=$3

sudo chmod 0644 $key_file

sudo ssh -o "StrictHostKeyChecking no" -i $key_file $vm_user@$vm_ip "sudo systemctl stop docker atomic-openshift-node"

if [ $? -ne 0 ]
then
   # die with unsuccessful shell script termination exit status # 3
   timestamp=$(date +"%Y-%m-%d %H-%M-%S")
   echo -ne $timestamp"\t[ERROR]\t"
   echo "An error occurred while stopping docker and atomic-openshift-node."
   exit 3
fi

sudo ssh -o "StrictHostKeyChecking no" -i $key_file $vm_user@$vm_ip "sudo rm -rf /var/lib/docker || true"

if [ $? -ne 0 ]
then
   # die with unsuccessful shell script termination exit status # 3
   timestamp=$(date +"%Y-%m-%d %H-%M-%S")
   echo -ne $timestamp"\t[ERROR]\t"
   echo "An error occurred while removing /var/lib/docker."
   exit 3
fi

sudo ssh -o "StrictHostKeyChecking no" -i $key_file $vm_user@$vm_ip "sudo mkdir -p /var/lib/docker"

if [ $? -ne 0 ]
then
   # die with unsuccessful shell script termination exit status # 3
   timestamp=$(date +"%Y-%m-%d %H-%M-%S")
   echo -ne $timestamp"\t[ERROR]\t"
   echo "An error occurred while creating /var/lib/docker."
   exit 3
fi

sudo ssh -o "StrictHostKeyChecking no" -i $key_file $vm_user@$vm_ip "sudo systemctl start docker atomic-openshift-node"

if [ $? -ne 0 ]
then
   # die with unsuccessful shell script termination exit status # 3
   timestamp=$(date +"%Y-%m-%d %H-%M-%S")
   echo -ne $timestamp"\t[ERROR]\t"
   echo "An error occurred while starting docker and atomic-openshift-node"
   exit 3
fi

sleep 5

sudo ssh -o "StrictHostKeyChecking no" -i $key_file $vm_user@$vm_ip "sudo systemctl start docker-flannel-rules.service"

if [ $? -ne 0 ]
then
   # die with unsuccessful shell script termination exit status # 3
   timestamp=$(date +"%Y-%m-%d %H-%M-%S")
   echo -ne $timestamp"\t[ERROR]\t"
   echo "An error occurred while restarting docker-flannel-rules.service"
   exit 3
fi
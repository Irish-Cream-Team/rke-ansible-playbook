#! /bin/bash


# Generate ssh key
ssh-keygen -t rsa -b 2048 -f /root/.ssh/id_rsa -q -N ""


username=$1
password=$2
hosts_file_path=$3
log_file_path=$4
for node in $(cat $hosts_file_path); do
    # if node as the value of [nodes] then skip
    if [ $node == "[nodes]" ]; then
        echo "skip node $node" >> $log_file_path
        continue
    fi
    # do cat to public key file and copy to remote host using ssh and log it to log file
    echo "copy ssh key to $node" >> $log_file_path
    cat /root/.ssh/id_rsa.pub | sshpass -p $password ssh $username@$node -o StrictHostKeyChecking=no "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
    # log the result of ssh command
    echo "ssh command result: $?" >> $log_file_path

    # test ssh connection, if success then log it to log file in local host
    ssh $username@$node -i /root/.ssh/id_rsa -o StrictHostKeyChecking=no "echo 'ssh connection success'" >> $log_file_path

done
#! /bin/bash

# log file /tmp/init/install_ssh_key.log

# Generate ssh key
ssh-keygen -t rsa -b 2048 -f /root/.ssh/id_rsa -q -N ""


username="adminz"
hosts_file_path="/tmp/init/hosts"
password=$1

for node in $(cat $hosts_file_path); do
    # if node as the value of [nodes] then skip
    if [ $node == "[nodes]" ]; then
        echo "skip node $node" >> /tmp/init/install_ssh_key.log
        continue
    fi
    # do cat to public key file and copy to remote host using ssh and log it to log file
    echo "copy ssh key to $node" >> /tmp/init/install_ssh_key.log
    cat /root/.ssh/id_rsa.pub | sshpass -p $password ssh $username@$node -o StrictHostKeyChecking=no "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
    # log the result of ssh command
    echo "ssh command result: $?" >> /tmp/init/install_ssh_key.log

    # test ssh connection, if success then log it to log file in local host
    ssh $username@$node -i /root/.ssh/id_rsa -o StrictHostKeyChecking=no "echo 'ssh connection success'" >> /tmp/init/install_ssh_key.log

done
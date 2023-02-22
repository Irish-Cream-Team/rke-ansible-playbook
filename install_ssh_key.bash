#! /bin/bash

# Generate ssh key
ssh-keygen -t rsa -b 2048 -f /root/.ssh/id_rsa -q -N ""

username="adminz"
hosts_file_path="hosts"
password=$1
for node in $(cat $hosts_file_path); do
    # if node as the value of [nodes] then skip
    if [ $node == "[nodes]" ]; then
        continue
    fi
    # do cat to public key file and copy to remote host using ssh
    cat /root/.ssh/id_rsa.pub | sshpass -p $password ssh $username@$node "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
done
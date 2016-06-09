#!/bin/bash

#Setting hostname
echo "$(hostname).node.$CONSUL_DC_NAME.consul" > /etc/hostname #setting consul hostname
sudo service hostname restart
sudo sh -c "echo \"$(hostname -I | awk '{print $1;}') $(hostname)\" >> /etc/hosts"

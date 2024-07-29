#!/bin/bash

# set your SSH hostname of the DNS server
server=igo

# copy the conf and rpz files from this repository to the home directory of your DNS server.
rsync -rtv . --include='rpz/***' --include=unbound.conf --exclude='*' $server:~/

# if conf is invaild, wait
ssh $server unbound-checkconf unbound.conf
if [ $? -ne 0 ]; then
    read
fi

# conf is valid, apply it
ssh -t $server 'sudo sh <<EOF
rsync -av --chown=unbound:unbound unbound.conf /usr/local/etc/unbound/
rsync -av --chown=unbound:unbound rpz/*.zone /usr/local/etc/unbound/
systemctl restart unbound
systemctl is-active unbound
EOF'

# if you're using WSL, DNS will ~~propagate~~.
ipconfig.exe /flushdns

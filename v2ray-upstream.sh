#!/usr/bin/env bash

read -p "Enter port (default 1310):" port

yes | sudo apt update

yes | sudo apt install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

yes | sudo apt install docker-ce

yes | apt install docker-compose

cd ~ || exit

git clone https://github.com/miladrahimi/v2ray-docker-compose.git

cd ~/v2ray-docker-compose/v2ray-upstream-server/ || exit

yes | ../utils/bbr.sh

sed -i "s/<UPSTREAM-UUID>/$(cat /proc/sys/kernel/random/uuid)/" v2ray/config/config.json

if [ "$port" != "" ]; then
    sed -i "s/1310/$port/" v2ray/config/config.json
    sed -i "s/1310:1310/$port:$port/" docker-compose.yml
fi

cd ~/v2ray-docker-compose/v2ray-upstream-server/ || exit

docker-compose up -d

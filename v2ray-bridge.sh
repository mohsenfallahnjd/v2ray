#!/usr/bin/env bash

function setShekan() {
    sed -i "s/nameserver/#nameserver/g" /etc/resolv.conf
    echo 'nameserver 178.22.122.100' >> /etc/resolv.conf
    echo 'nameserver 185.51.200.2' >> /etc/resolv.conf
}

while : ; do
    read -p "Enter upstream ip:" upstreamIp
    [[ "$upstreamIp" == "" ]] || break
done

while : ; do
    read -p "Enter upstream uuid:" upstreamUUID
    [[ "$upstreamUUID" == "" ]] || break
done

read -p "Enter plus number with port:" port

setShekan

yes | sudo apt update

setShekan

yes | sudo apt install apt-transport-https ca-certificates curl software-properties-common

setShekan

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

setShekan

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

setShekan

yes | sudo apt install docker-ce

setShekan

yes | apt install docker-compose

cd ~ || exit

git clone https://github.com/miladrahimi/v2ray-docker-compose.git

cd ~/v2ray-docker-compose/v2ray-bridge-server/ || exit

yes | ../utils/bbr.sh

sed -i "s/<SHADOWSOCKS-PASSWORD>/Wom@NL!f3FR33DoM/" v2ray/config/config.json
sed -i "s/<BRIDGE-UUID>/$(cat /proc/sys/kernel/random/uuid)/" v2ray/config/config.json
sed -i "s/<UPSTREAM-IP>/$upstreamIp/" v2ray/config/config.json
sed -i "s/<UPSTREAM-UUID>/$upstreamUUID/" v2ray/config/config.json

if [ "$port" != "" ]; then
    sed -i "s/1010/$(( 1010 + port ))/g" docker-compose.yml
    sed -i "s/1110/$(( 1110 + port ))/g" docker-compose.yml
    sed -i "s/1210/$(( 1210 + port ))/g" docker-compose.yml
    sed -i "s/1310/$(( 1310 + port ))/g" docker-compose.yml

    sed -i "s/1010/$(( 1010 + port ))/g" v2ray/config/config.json
    sed -i "s/1110/$(( 1110 + port ))/g" v2ray/config/config.json
    sed -i "s/1210/$(( 1210 + port ))/g" v2ray/config/config.json
    sed -i "s/1310/$(( 1310 + port ))/g" v2ray/config/config.json
fi

cd ~/v2ray-docker-compose/v2ray-bridge-server/ || exit

docker-compose up -d

cd ~/v2ray-docker-compose/v2ray-bridge-server/ || exit


echo ""
echo ""
echo "================================================================"

./clients.py

echo "================================================================"
echo ""
echo ""


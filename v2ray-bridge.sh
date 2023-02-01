#!/usr/bin/env bash

setShekan() {
    sed -i "s/nameserver/#nameserver/g" /etc/resolv.conf
    echo 'nameserver 178.22.122.100' >> /etc/resolv.conf
    echo 'nameserver 185.51.200.2' >> /etc/resolv.conf
}

sleepClear() {
    sleep 3;
    clear
}

while : ; do
    read -p "Enter upstream ip: " upstreamIp
    [[ "$upstreamIp" == "" ]] || break
done

while : ; do
    read -p "Enter upstream uuid: " upstreamUUID
    [[ "$upstreamUUID" == "" ]] || break
done

if [[ $1 == "-p" ]]; then
    read -p "Enter upstream port (default 1310): " port
fi

setShekan

yes | sudo apt update

setShekan
sleepClear

yes | sudo apt install apt-transport-https ca-certificates curl software-properties-common

setShekan
sleepClear

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

setShekan
sleepClear

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

setShekan
sleepClear

yes | sudo apt install docker-ce

setShekan
sleepClear

yes | apt install docker-compose

sleepClear

cd ~ || exit

git clone https://github.com/miladrahimi/v2ray-docker-compose.git

cd ~/v2ray-docker-compose/v2ray-bridge-server/ || exit

yes "" | ../utils/bbr.sh

echo ""
echo ""
echo "Set configs..."
echo ""
echo ""

sed -i "s/<SHADOWSOCKS-PASSWORD>/Wom@NL!f3FR33DoM/" v2ray/config/config.json
sed -i "s/<BRIDGE-UUID>/$(cat /proc/sys/kernel/random/uuid)/" v2ray/config/config.json
sed -i "s/<UPSTREAM-IP>/$upstreamIp/" v2ray/config/config.json
sed -i "s/<UPSTREAM-UUID>/$upstreamUUID/" v2ray/config/config.json

echo ""
echo "Configs added successfully."
echo ""
echo ""

if [ "$port" != "" ]; then
    diff=$(( 1310 - port ))
    sed -i "s/1010/$(( 1010 - diff ))/g" docker-compose.yml
    sed -i "s/1110/$(( 1110 - diff ))/g" docker-compose.yml
    sed -i "s/1210/$(( 1210 - diff ))/g" docker-compose.yml
    sed -i "s/1310/$(( 1310 - diff ))/g" docker-compose.yml

    sed -i "s/1010/$(( 1010 - diff ))/g" v2ray/config/config.json
    sed -i "s/1110/$(( 1110 - diff ))/g" v2ray/config/config.json
    sed -i "s/1210/$(( 1210 - diff ))/g" v2ray/config/config.json
    sed -i "s/1310/$(( 1310 - diff ))/g" v2ray/config/config.json

    echo "Port Changed."
    echo ""
    echo ""
fi

cd ~/v2ray-docker-compose/v2ray-bridge-server/ || exit

docker-compose up -d

cd ~/v2ray-docker-compose/v2ray-bridge-server/ || exit

echo ""
echo ""
echo "================================================================"
echo ""

./clients.py

echo ""
echo "================================================================"
echo ""
echo ""


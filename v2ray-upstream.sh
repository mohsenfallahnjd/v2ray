#!/usr/bin/env bash

sleepClear() {
    sleep 3;
    clear
}

if [[ $1 == "-p" ]]; then
    read -p "Enter port (default 1310):" port
fi

yes | sudo apt update

sleepClear

yes | sudo apt install apt-transport-https ca-certificates curl software-properties-common

sleepClear

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sleepClear

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

sleepClear

yes | sudo apt install docker-ce

sleepClear

yes | apt install docker-compose

sleepClear

cd ~ || exit

git clone https://github.com/miladrahimi/v2ray-docker-compose.git

cd ~/v2ray-docker-compose/v2ray-upstream-server/ || exit

yes "" | ../utils/bbr.sh

uuid=$(cat /proc/sys/kernel/random/uuid)

sed -i "s/<UPSTREAM-UUID>/$uuid/" v2ray/config/config.json

echo ""
echo ""
echo "Uuid added successfully."
echo ""
echo ""


if [ "$port" != "" ]; then
    sed -i "s/1310/$port/" v2ray/config/config.json
    sed -i "s/1310/$port/g" docker-compose.yml

    echo "Change port ..."
    echo ""
    echo ""
fi

cd ~/v2ray-docker-compose/v2ray-upstream-server/ || exit

docker-compose up -d

echo ""
echo ""
echo "================================================================"
echo "<UPSTREAM-IP> => $(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')"
echo "<UPSTREAM-UUID> => $uuid"
if [ "$port" != "" ]; then
    echo "<UPSTREAM-PORT> => $port"
fi
echo "================================================================"
echo ""
echo ""
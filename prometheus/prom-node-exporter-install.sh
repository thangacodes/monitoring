#### This is shows us, how to install node-exported on cloud machines

#!/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "You should run as root user"
  exit 1
fi

if [ -d /opt/node_exporter ]; then
  rm -rf /opt/node_exporter
fi

URL=$(curl -L -s https://prometheus.io/download/  | grep tar | grep node_exporter | grep linux-amd64  | sed -e "s|>| |g" -e 's|<| |g' -e 's|"| |g' |xargs -n1 | grep ^http)

FILENAME=$(echo $URL | awk -F / '{print $NF}')
DIRNAME=$(echo $FILENAME | sed -e 's/.tar.gz//')

cd /opt
curl -s -L -O $URL
tar -xf $FILENAME
rm -f $FILENAME
mv $DIRNAME node_exporter

curl -s https://gitlab.com/thecloudcareers/opensource/-/raw/master/node_exporter.service >/etc/systemd/system/node_exporter.service
systemctl enable node_exporter
systemctl start node_exporter

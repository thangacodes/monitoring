##### This is going to be show us, how to install grafana on cloud machines


###################### Script starts here #####################################

#!/bin/bash

echo '[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt' >/etc/yum.repos.d/grafana.repo

yum install grafana -y
systemctl enable grafana-server
systemctl start grafana-server


### Note: By default, if the cloud instances doesn't have open source packages repository, we need to add it to the repos.d in linux flavors.
By default location of repository is "etc/yum.repos.d"

```bash

How to make use of ansible playbook to configure prometheus?

$ ansible-playbook install_config_prometheus.yaml 

The install_config_prometheus.yaml file is used to perform the following actions on the localhost.

a) Downloads Prometheus

b) Creates a dedicated prometheus user

c) Installs Prometheus binaries to /opt/prometheus

d) Sets up systemd service (prometheus.service)

e) Starts and enables the Prometheus service
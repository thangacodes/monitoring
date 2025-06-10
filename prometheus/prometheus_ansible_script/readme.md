```bash

How to make use of ansible playbook to configure prometheus on localhost or a single host?

$ ansible-playbook install_config_prometheus.yaml 

The install_config_prometheus.yaml file is used to perform the following actions on the localhost.

a) Downloads Prometheus

b) Creates a dedicated prometheus user

c) Installs Prometheus binaries to /opt/prometheus

d) Sets up systemd service (prometheus.service)

e) Starts and enables the Prometheus service

[OR]

Another approach is to invoke an Ansible role that performs the same functionality, which is more flexible when setting up multiple hosts simultaneously.

$ ansible-playbook invoke_prometheus_config_role.yaml

Below is the folder structure for prometheus-config:

📁 prometheus-config
.

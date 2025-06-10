```bash

Here are the default ports for each services like Grafana, Prometheus, Node Exporter, Blackbox Exporter

Grafana: 3000 (default HTTP port for the Grafana web UI)

Prometheus: 9090 (default port for Prometheus server HTTP)

Node Exporter: 9100 (default port for node_exporter metrics endpoint)

Blackbox Exporter: 9115 (default port for blackbox_exporter metrics endpoint)


How to make use of ansible playbook to configure prometheus?

$ ansible-playbook install_config_prometheus.yaml 

The install_config_prometheus.yaml file is used to perform the following actions on the localhost.

a) Downloads Prometheus

b) Creates a dedicated prometheus user

c) Installs Prometheus binaries to /opt/prometheus

d) Sets up systemd service (prometheus.service)

e) Starts and enables the Prometheus service

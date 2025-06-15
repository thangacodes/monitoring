```bash

📁 Folder Structure
.
├── alertmanager
│   ├── am-install.yaml
│   └── readme.md
├── blackbox_exporter
│   └── blackbox_exporter_install.sh
├── grafana_dash
│   ├── grafana_download_install.yaml
│   └── grafana_install.sh
├── node_exporter
│   └── node-exporter-install.sh
├── prometheus_ansible_script
│   ├── install_config_prometheus.yaml
│   ├── invoke_prometheus_config_role.yaml
│   ├── prometheus-config
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   └── prometheus.service.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── prometheus-install.sh
│   ├── prometheus.service
│   └── readme.md
└── readme.md

13 directories, 20 files


Here are the default ports for each services like AlertManager, Grafana, Prometheus, Node Exporter, Blackbox Exporter

AlertManager: 9093 & 9094 (Web UI & Cluster Communication)

Grafana: 3000 (default HTTP port for the Grafana web UI)

Prometheus: 9090 (default port for Prometheus server HTTP)

Node Exporter: 9100 (default port for node_exporter metrics endpoint)

Blackbox Exporter: 9115 (default port for blackbox_exporter metrics endpoint)


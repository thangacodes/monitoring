
# Monitoring: (DataDog and Prometheus)

1) Prometheus is an open-source monitoring tool, and Grafana is a visualization dashboard for metrics
   and traces of the infrastructure that we provision and configure for alerting.

   [promotheus](https://github.com/thangacodes/monitoring/tree/main/prometheus)

2) Prometheus ansible scripts

   [ansible-for-prometheus](https://github.com/thangacodes/monitoring/tree/main/prometheus/prometheus_ansible_script)

3) Cloudwatch-exporter ansible role

   [cloudwatch-exporter](https://github.com/thangacodes/monitoring/tree/main/prometheus/cwatch-exporter)

4) AlertManager ansible scripts

   [alertmanager](https://github.com/thangacodes/monitoring/tree/main/prometheus/alertmanager)

5) Datadog is a commercial product for infrastructure monitoring and application performance management (APM).

6) I have included this here for installing the Datadog agent on remote machines, specifically AWS EC2 instances
   using Ansible automation.

   [datadog-installation](https://github.com/thangacodes/monitoring/tree/main/datadog)

7) I have created a Terraform script to provision and test datadog-agent on an EC2 instance in AWS.

   [ec2-terraform](https://github.com/thangacodes/monitoring/tree/main/ec2_provision)

8) I have updated Terraform script to create monitor for AWS EC2

   [datadog-monitor-create](https://github.com/thangacodes/monitoring/tree/main/datadog/datadog-terraform/cpu-alert-create)
   

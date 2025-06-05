
Monitoring:

1) Prometheus is an open-source monitoring tool, and Grafana is a visualization dashboard for metrics
   and traces of the infrastructure that we provision and configure for alerting.

2) Datadog is a commercial product for infrastructure monitoring and application performance management (APM).

3) I have included this here for installing the Datadog agent on remote machines, specifically AWS EC2 instances
   using Ansible automation.

   [datadog-installation](https://github.com/thangacodes/monitoring/tree/main/datadog)

4) I have created a Terraform script to provision and test datadog-agent on an EC2 instance in AWS.

   [ec2-terraform](https://github.com/thangacodes/monitoring/tree/main/ec2_provision)
   

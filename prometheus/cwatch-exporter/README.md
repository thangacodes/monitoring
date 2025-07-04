```bash

Role Name: cwatch-exporter
---------
An Ansible role to install and manage the AWS CloudWatch Exporter on a prometheus server. 
This role copies the CloudWatch Exporter JAR and configuration files, sets up a systemd service, and ensures the exporter runs reliably to expose AWS RDS metrics to Prometheus.

Requirements:
------------
Java (OpenJDK 11 or compatible) must be installed on the target host.

The target host should have network access to AWS CloudWatch.

Prometheus server must be configured to scrape metrics from the exporter's listening port.

The role assumes a Linux host with systemd as the init system.

AWS credentials and permissions must be configured on the bastion/monitoring host for the exporter to access CloudWatch metrics.

Role Variables:
--------------
These variables can be customized in defaults/main.yml or overridden when including the role.

cloudwatch_exporter_dir
cloudwatch_exporter_jar
cloudwatch_exporter_config
cloudwatch_exporter_port
cloudwatch_exporter_log
run_as_user
java_home

Dependencies:
------------
This role does not depend on any other Ansible roles.
Ensure Java is installed on the target host before applying this role..

Example Playbook:
----------------
Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

# rds-cwatch.yaml
- hosts: localhost  
  become: yes
  roles:
    - role: cwatch-exporter
      # vars: // Default variables can be overridden using the vars section in the role invoke yaml(path: cwatch-exporter/defaults/main.yaml)
      # cloudwatch_exporter_port: 9106
      # run_as_user: ec2-user
      # cloudwatch_exporter_dir: /home/ec2-user/cloudwatch_exporter_rds

How do i run role invoke ansible playbook?
ansible-playbook rds-cwatch.yaml


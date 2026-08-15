# CloudWatch Agent Automation with Ansible:

This repository contains Ansible playbooks to automate the installation and configuration of the Amazon CloudWatch Agent on Linux EC2 instances.

## Overview

The automation performs the following tasks:

- Installs the Amazon CloudWatch Agent.
- Configures the CloudWatch Agent using a predefined configuration file.
- Starts and enables the CloudWatch Agent service.
- Verifies that the agent is running successfully.

## Project Structure

```
├── inventory/
│   └── hosts.ini
├── playbooks/
│   └── invoke_role.yaml

├── roles/ca_agent_role
    ├── README.md
    ├── defaults
    │     └── main.yml
    ├── files
    ├── handlers
    │     └── main.yml
    ├── meta
    │     └── main.yml
    ├── tasks
    │   └── main.yml
    ├── templates
    ├── tests
    ├── inventory
    │   └── test.yml
    └── vars
    │    └── main.yml

9 directories, 8 files

```

## Prerequisites

- Ansible installed on the control node.
- SSH access to the target EC2 instances.
- AWS IAM role attached to the instances with permissions for CloudWatch.
- Amazon Linux, RHEL, CentOS, Ubuntu, or another supported Linux distribution.

## Configuration

Update the CloudWatch Agent configuration file according to your monitoring requirements before running the playbook.

Example metrics that can be collected:

- CPU utilization
- Memory usage
- Disk utilization
- Disk I/O
- Network statistics
- Log files

## Running a single Playbook to get install and configure CA-Agent on an EC2 machine.

Execute the playbook using:

```bash
ansible-playbook -i inventory/hosts playbooks/install_cloudwatch_agent.yml
```

## Invoking an ansible role from a ansible-playbook

```bash
ansible-playbook -i inventory/hosts invoke_role.yaml
```

## Verification

Verify that the CloudWatch Agent service is running:

```bash
sudo systemctl status amazon-cloudwatch-agent
```

Check the agent status:

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
```

## Expected Outcome

After successful execution:

- Amazon CloudWatch Agent is installed.
- Agent configuration is applied.
- CloudWatch Agent service is enabled.
- Metrics and logs are sent to Amazon CloudWatch.

## Notes

- Ensure the EC2 instance has internet access or access to the required AWS endpoints.
- Verify the IAM role includes the necessary CloudWatch permissions.
- Update the configuration file whenever additional metrics or log files need to be monitored.

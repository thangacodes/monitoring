```bash 

This automation installs Datadog agent on remote AWS EC2 instances using an Ansible playbook.

Folder structure for the role called "ddog"

📁 datadog-terraform
📁 datadog-ansible
📁 ddog
.
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── README.md
├── tasks
│   └── main.yml
├── templates
│   └── datadog.yaml.j2
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
9 directories, 9 files

Link to refer to Datadog Ansible:

[datadog-ansible](https://github.com/thangacodes/monitoring/blob/main/datadog/datadog-ansible/README.md)

Link to refer to Datadog Terraform:

[datadog-terraform](https://github.com/thangacodes/monitoring/blob/main/datadog/datadog-terraform/README.md)

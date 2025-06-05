```bash

This automation installs Datadog agent on remote AWS EC2 instances using an Ansible playbook.

Folder structure for the role called "ddog"

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

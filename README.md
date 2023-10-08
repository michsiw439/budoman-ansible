# Budoman-Ansible

The **budoman-ansible** project serves as a central automation and configuration management tool designed specifically for streamlining and enhancing the environments of two primary applications: **budoman-front** and **budoman-backend**.

## Initial setup
```bash
1. Make sure that you have installed ansible on local machine
2. Make sure that you have require vault-password for specific environment
```

## Features

### 1. Environment Configuration
Playbooks for deploying decrypted environment variables, ensuring both applications have the necessary settings without compromising security.

Sample deploying env variables to budoman-backend project
```bash
ansible-playbook -i ./inventories/budoman-backend/development/hosts.yml playbooks/budoman-backend/update-env.yml --vault-password-file vault_passwords/development.txt
```

### 2. Cron Automation
A dedicated playbook for configuring crontab tasks, allowing for automated and scheduled operations.
Sample cron configuration
```bash
ansible-playbook -i ./inventories/budoman-backend/development/hosts.yml playbooks/budoman-backend/cron/send_newsletter.yml
```

### 3. Script Deployment
A playbook designed for the seamless upload and integration of bash scripts into the applications.

By harnessing the power of Ansible, **budoman-ansible** facilitates a smoother, more organized, and secure operational flow for both the frontend and backend environments of the Budoman suite.
Sample monitoring configuration
```bash
ansible-playbook -i ./inventories/budoman-backend/development/hosts.yml playbooks/budoman-backend/cron/configure_monitoring.yml
```

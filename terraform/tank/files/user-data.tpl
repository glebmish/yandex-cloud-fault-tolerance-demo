#cloud-config
datasource:
  Ec2:
    strict_id: false
ssh_pwauth: no
users:
- name: ${user}
  sudo: ALL=(ALL) NOPASSWD:ALL
  shell: /bin/bash
  ssh_authorized_keys:
  - ${ssh-key}

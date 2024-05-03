# Ansible Playbook: Capture System Information and Store in File

This Ansible playbook gathers various system information from target servers and stores it in a file.

## Prerequisites

- Ansible installed on the control machine.
- SSH access to the target servers from the control machine.
- Proper permissions to execute commands on the target servers.

## Usage

1. Modify the `inventory.ini` file to specify the target server(s) under the appropriate group.
2. Update the playbook `capture_system_info.yaml` as needed.
3. Run the playbook:

```bash
ansible-playbook -i inventory.ini capture_system_info.yaml

```bash
## What It Does
Gathers system information such as uptime, disk usage, contents of /etc/fstab and /etc/shadow, network interfaces information, routing table, detailed network interfaces, and AD information.
Stores the gathered information in a file located at /u/spool/30/Nutanix_Migration/premigrationcheck.<date>.<time>.

```bash
## Additional Notes
This playbook assumes the target servers are Linux-based.
Ensure proper permissions are set on the destination directory (/u/spool/30/Nutanix_Migration) to allow writing the file.
Review and customize the playbook according to your specific requirements.

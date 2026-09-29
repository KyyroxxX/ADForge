# ADForge

**Active Directory Security & Administration Lab**

ADForge is a Windows Active Directory laboratory designed to demonstrate
enterprise identity management, PowerShell automation, security auditing,
and baseline hardening practices.

## Objectives

- Deploy and configure an Active Directory domain.
- Manage users, groups, and Organizational Units (OUs).
- Automate administrative tasks using PowerShell.
- Implement and document Group Policy Objects (GPOs).
- Audit Active Directory configurations.
- Identify common security misconfigurations.
- Apply basic security hardening recommendations.

## Architecture

The laboratory is designed around the following components:

| Component | Purpose |
|---|---|
| Windows Server | Domain Controller |
| Active Directory Domain Services | Identity and directory management |
| DNS | Domain name resolution |
| Group Policy | Centralized configuration |
| PowerShell | Administration and automation |
| Windows Client | Domain-joined workstation |

## Repository Structure

```text
ADForge/
├── configs/
├── docs/
├── lab/
├── screenshots/
├── scripts/
├── .gitignore
├── LICENSE
└── README.md

## Project Status

🚧 Initial development

## Security Notice

This project is intended for educational purposes and isolated lab environments.
Do not execute configuration or auditing scripts against systems without
explicit authorization.

## Roadmap

- [ ] Define laboratory topology
- [ ] Document domain deployment
- [ ] Create user and OU management scripts
- [ ] Implement GPO configuration documentation
- [ ] Develop Active Directory auditing scripts
- [ ] Document security findings
- [ ] Add screenshots and usage examples

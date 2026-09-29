# ADForge - Laboratory Architecture

## 1. Overview

ADForge is an isolated Active Directory laboratory designed to demonstrate
Windows domain administration, identity management, PowerShell automation,
and security auditing.

## 2. Network Topology

The laboratory uses an isolated virtual network.

| Hostname | Operating System | Role | IP Address |
|---|---|---|---|
| AD01 | Windows Server | Domain Controller / DNS | 192.168.100.10 |
| CLIENT01 | Windows 10/11 | Domain-joined workstation | 192.168.100.20 |

## 3. Domain Configuration

| Property | Value |
|---|---|
| Domain | adforge.test |
| NetBIOS Name | ADFORGE |
| Domain Controller | AD01 |
| DNS Server | 192.168.100.10 |
| Network | 192.168.100.0/24 |

## 4. Active Directory Components

- Active Directory Domain Services (AD DS)
- Domain Name System (DNS)
- Organizational Units (OUs)
- User and security group management
- Group Policy Objects (GPOs)
- PowerShell administration

## 5. Security Boundaries

The laboratory must remain isolated from production networks.

- Use dedicated virtual machines.
- Avoid exposing domain services to public networks.
- Use snapshots before major configuration changes.
- Never commit real credentials or secrets.
- Use test accounts for demonstrations.

## 6. Planned Implementation

1. Deploy Windows Server.
2. Configure static networking.
3. Install AD DS and DNS.
4. Promote AD01 to Domain Controller.
5. Create the domain structure.
6. Join CLIENT01 to the domain.
7. Implement administration scripts.
8. Perform security audits.

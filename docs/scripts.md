# ADForge PowerShell Scripts

## Initialize-ADStructure.ps1

### Purpose

Creates the organizational unit hierarchy required by the ADForge laboratory.

### Requirements

- Windows Server with Active Directory Domain Services.
- ActiveDirectory PowerShell module.
- Appropriate delegated permissions.

### Parameters

| Parameter | Description |
|---|---|
| DomainDN | Distinguished Name of the target domain |

### Features

- Creates the predefined OU hierarchy.
- Detects existing organizational units.
- Supports PowerShell WhatIf simulation.
- Enables accidental deletion protection on created OUs.
- Reports creation results and errors.

### Example

```powershell
.\Initialize-ADStructure.ps1 -WhatIf


Security
Run only in an authorized, isolated laboratory.
Review the target domain before executing changes.

## Create-ADForgeGroups.ps1

### Purpose

Creates predefined global security groups for the ADForge laboratory.

### Groups

| Group | Purpose |
|---|---|
| GG_IT | IT department |
| GG_HR | HR department |
| GG_Finance | Finance department |
| GG_Helpdesk | Helpdesk operations |

### Features

- Creates global security groups.
- Checks whether groups already exist.
- Supports WhatIf simulation.
- Uses centralized group organization.

### Example

```powershell
.\Create-ADForgeGroups.ps1 -WhatIf

Security
Run only in an authorized, isolated lab.

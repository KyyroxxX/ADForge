#Requires -Modules ActiveDirectory

<#
.SYNOPSIS
    Initializes the ADForge Active Directory structure.

.DESCRIPTION
    Creates the organizational units required by the ADForge lab.
    Existing organizational units are skipped.

.NOTES
    Requires Active Directory PowerShell module and appropriate permissions.
    Intended for isolated lab environments.
#>

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [string]$DomainDN = "DC=adforge,DC=test"
)

$ErrorActionPreference = "Stop"

$OrganizationalUnits = @(
    @{
        Name = "ADForge"
        Path = $DomainDN
    },
    @{
        Name = "Users"
        Path = "OU=ADForge,$DomainDN"
    },
    @{
        Name = "IT"
        Path = "OU=Users,OU=ADForge,$DomainDN"
    },
    @{
        Name = "HR"
        Path = "OU=Users,OU=ADForge,$DomainDN"
    },
    @{
        Name = "Finance"
        Path = "OU=Users,OU=ADForge,$DomainDN"
    },
    @{
        Name = "Groups"
        Path = "OU=ADForge,$DomainDN"
    },
    @{
        Name = "Workstations"
        Path = "OU=ADForge,$DomainDN"
    },
    @{
        Name = "Servers"
        Path = "OU=ADForge,$DomainDN"
    },
    @{
        Name = "ServiceAccounts"
        Path = "OU=ADForge,$DomainDN"
    }
)

Write-Information "[+] Starting ADForge structure initialization..." -ForegroundColor Cyan

Import-Module ActiveDirectory

foreach ($OU in $OrganizationalUnits) {

    $OUName = $OU.Name
    $ParentPath = $OU.Path
    $DistinguishedName = "OU=$OUName,$ParentPath"

    try {
        $ExistingOU = Get-ADOrganizationalUnit `
            -Identity $DistinguishedName `
            -ErrorAction SilentlyContinue

        if ($ExistingOU) {
            Write-Information "[=] Already exists: $DistinguishedName" -ForegroundColor Yellow
            continue
        }

        if ($PSCmdlet.ShouldProcess($DistinguishedName, "Create Organizational Unit")) {

            New-ADOrganizationalUnit `
                -Name $OUName `
                -Path $ParentPath `
                -ProtectedFromAccidentalDeletion $true

            Write-Information "[+] Created: $DistinguishedName" -ForegroundColor Green
        }
    }
    catch {
        Write-Error "Failed to create ${DistinguishedName}: $_"
        exit 1
    }
}

Write-Information "[+] ADForge structure initialization completed." -ForegroundColor Green

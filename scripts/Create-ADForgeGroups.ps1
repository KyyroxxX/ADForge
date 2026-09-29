#:%s/Write-Information/Write-Information/gRequires -Modules ActiveDirectory

<#
.SYNOPSIS
    Creates ADForge security groups.

.DESCRIPTION
    Creates predefined global security groups
    inside the ADForge Groups OU.

.NOTES
    Intended for isolated Active Directory labs.
#>

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]

param(
    [string]$DomainDN = "DC=adforge,DC=test"
)

$ErrorActionPreference = "Stop"

$Groups = @(
    @{
        Name = "GG_IT"
        Description = "IT Department Security Group"
    },
    @{
        Name = "GG_HR"
        Description = "HR Department Security Group"
    },
    @{
        Name = "GG_Finance"
        Description = "Finance Department Security Group"
    },
    @{
        Name = "GG_Helpdesk"
        Description = "Helpdesk Support Security Group"
    }
)

$GroupPath = "OU=Groups,OU=ADForge,$DomainDN"

try {
    Import-Module ActiveDirectory -ErrorAction Stop

    foreach ($Group in $Groups) {

        $GroupName = $Group.Name

        $ExistingGroup = Get-ADGroup `
            -Filter "SamAccountName -eq '$GroupName'" `
            -ErrorAction SilentlyContinue

        if ($ExistingGroup) {
            Write-Information "[=] Already exists: $GroupName" -ForegroundColor Yellow
            continue
        }

        if ($PSCmdlet.ShouldProcess($GroupName, "Create security group")) {

            New-ADGroup `
                -Name $GroupName `
                -SamAccountName $GroupName `
                -GroupCategory Security `
                -GroupScope Global `
                -Path $GroupPath `
                -Description $Group.Description

            Write-Information "[+] Created: $GroupName" -ForegroundColor Green
        }
    }

    Write-Information "[+] Group initialization completed." -ForegroundColor Cyan
}
catch {
    Write-Error "Group creation failed: $_"
    exit 1
}

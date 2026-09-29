#Requires -Modules ActiveDirectory

<#
.SYNOPSIS
    Audits Active Directory user accounts.

.DESCRIPTION
    Collects account status, password settings and last logon
    information for security auditing purposes.

.PARAMETER ExportPath
    Destination CSV file for the audit report.

.EXAMPLE
    .\Get-ADForgeAudit.ps1

.EXAMPLE
    .\Get-ADForgeAudit.ps1 -ExportPath ".\audit.csv"
#>

[CmdletBinding()]
param(
    [string]$ExportPath = ".\reports\adforge-audit.csv"
)

$ErrorActionPreference = "Stop"

Write-Information "[+] Starting ADForge audit..." -ForegroundColor Cyan

try {
    Import-Module ActiveDirectory -ErrorAction Stop

    $Users = Get-ADUser -Filter * -Properties `
        Enabled,
        PasswordNeverExpires,
        PasswordLastSet,
        LastLogonDate,
        Created,
        PasswordExpired

    $AuditResults = foreach ($User in $Users) {

        [PSCustomObject]@{
            Username             = $User.SamAccountName
            Enabled              = $User.Enabled
            PasswordNeverExpires = $User.PasswordNeverExpires
            PasswordExpired      = $User.PasswordExpired
            PasswordLastSet      = $User.PasswordLastSet
            LastLogonDate        = $User.LastLogonDate
            Created              = $User.Created
        }
    }

    $DisabledAccounts = @($AuditResults | Where-Object { -not $_.Enabled })
    $NeverExpires = @($AuditResults | Where-Object { $_.PasswordNeverExpires })

    Write-Information ""
    Write-Information "========== ADForge Audit ==========" -ForegroundColor Cyan
    Write-Information "Total users: $($AuditResults.Count)"
    Write-Information "Disabled accounts: $($DisabledAccounts.Count)" -ForegroundColor Yellow
    Write-Information "Passwords never expire: $($NeverExpires.Count)" -ForegroundColor Yellow
    Write-Information "===================================" -ForegroundColor Cyan

    $Directory = Split-Path -Parent $ExportPath

    if ($Directory -and -not (Test-Path $Directory)) {
        New-Item -ItemType Directory -Path $Directory -Force | Out-Null
    }

    $AuditResults | Export-Csv -Path $ExportPath -NoTypeInformation -Encoding UTF8

    Write-Information "[+] Report exported to: $ExportPath" -ForegroundColor Green
}
catch {
    Write-Error "ADForge audit failed: $_"
    exit 1
}

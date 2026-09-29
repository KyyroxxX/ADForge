#Requires -Modules ActiveDirectory

<#
.SYNOPSIS
    Creates fictional ADForge lab users.

.DESCRIPTION
    Creates a user in the selected department OU.
    Accounts are disabled by default for safety.
    A cryptographically random temporary password is generated.
    The password is never displayed or written to disk.

.PARAMETER Username
    SamAccountName of the new user.

.PARAMETER FirstName
    User's first name.

.PARAMETER LastName
    User's last name.

.PARAMETER Department
    IT, HR or Finance.

.PARAMETER EnableAccount
    Explicitly enables the account after creation.
#>

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^[a-zA-Z0-9._-]{1,20}$')]
    [string]$Username,

    [Parameter(Mandatory)]
    [string]$FirstName,

    [Parameter(Mandatory)]
    [string]$LastName,

    [Parameter(Mandatory)]
    [ValidateSet('IT', 'HR', 'Finance')]
    [string]$Department,

    [switch]$EnableAccount
)

$ErrorActionPreference = "Stop"

$DomainDN = "DC=adforge,DC=test"
$TargetOU = "OU=$Department,OU=Users,OU=ADForge,$DomainDN"

$PasswordBytes = $null
$TemporaryPassword = $null
$SecurePassword = $null

try {
    Import-Module ActiveDirectory -ErrorAction Stop

    $ExistingUser = Get-ADUser `
        -Filter "SamAccountName -eq '$Username'" `
        -ErrorAction SilentlyContinue

    if ($ExistingUser) {
        throw "User '$Username' already exists."
    }

    # Generate a cryptographically random temporary password.
    $PasswordBytes = [System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32)

    try {
        $TemporaryPassword = [Convert]::ToBase64String($PasswordBytes) + "aA1!"

        $SecurePassword = New-Object System.Security.SecureString

        foreach ($Character in $TemporaryPassword.ToCharArray()) {
            $SecurePassword.AppendChar($Character)
        }

        $SecurePassword.MakeReadOnly()
    }
    finally {
        [Array]::Clear($PasswordBytes, 0, $PasswordBytes.Length)
        $TemporaryPassword = $null
    }

    $Parameters = @{
        Name                  = "$FirstName $LastName"
        GivenName             = $FirstName
        Surname               = $LastName
        SamAccountName        = $Username
        UserPrincipalName     = "$Username@adforge.test"
        Path                  = $TargetOU
        AccountPassword       = $SecurePassword
        Enabled               = $false
        ChangePasswordAtLogon = $true
    }

    if ($PSCmdlet.ShouldProcess($Username, "Create disabled lab user")) {

        New-ADUser @Parameters -ErrorAction Stop

        Write-Information "User created: $Username" -InformationAction Continue

        if ($EnableAccount) {
            Enable-ADAccount -Identity $Username -ErrorAction Stop

            Write-Information "Account enabled." -InformationAction Continue
        }
        else {
            Write-Information "Account remains disabled." -InformationAction Continue
        }

        Write-Warning "A temporary password was generated but not displayed. Reset it through a secure administrative process before enabling the account."
    }
}
catch {
    Write-Error "User creation failed: $_"
    exit 1
}
finally {
    if ($PasswordBytes) {
        [Array]::Clear($PasswordBytes, 0, $PasswordBytes.Length)
    }

    $TemporaryPassword = $null
    $SecurePassword = $null
}

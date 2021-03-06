param(
	[string]$DomainNetBIOSName,
    [string]$DomainAdminUser,
    [string]$DomainAdminPassword,
	[string]$DDCServerNetBIOSName1    )

$Pass = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
$User = $DomainNetBIOSName + "\" + $DomainAdminUser
$Database_CredObject = New-Object System.Management.Automation.PSCredential -ArgumentList ($User, $Pass)


# Set Powershell Compatibility Mode
Set-StrictMode -Version 2.0

# Any failure is a terminating failure.
$ErrorActionPreference = 'Stop'

$logpath = "C:\cfn\log\citrix"

#create logging folder
mkdir $logpath -force

$logfile = join-path $logpath "add-xdcontroller.log"
start-transcript -path $logfile -noclobber
$env:PSModulePath = $env:PSModulePath + ";C:\Program Files\Citrix\XenDesktopPoshSdk\Module\Citrix.XenDesktop.Admin.V1\"
# Add-PSSnapin Citrix.*
import-module -name Citrix.Xendesktop.Admin -Verbose


Add-PSSnapin Citrix.*
Add-XDController -SiteControllerAddress $DDCServerNetBIOSName1 -DatabaseCredentials $Database_CredObject 

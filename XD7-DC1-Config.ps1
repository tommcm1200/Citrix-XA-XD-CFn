param(
	[string]$DomainNetBIOSName,
    [string]$DomainAdminUser,
    [string]$DomainAdminPassword,
	[string]$DDCServerNetBIOSName1,
    [string]$WSFCNode1NetBIOSName
    )
# -------------------------------------------
# Site Configuration
# -------------------------------------------

$DatabaseServer = $WSFCNode1NetBIOSName
$DatabaseName_Site = "XD7-DB_Site"
$DatabaseName_Logging = "XD7-DB_Logging"
$DatabaseName_Monitor = "XD7-DB_Monitor"
$XD7Site = "XD7-on-AWS-FARM"

$Pass = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
$User = $DomainNetBIOSName + "\" + $DomainAdminUser
$Database_CredObject = New-Object System.Management.Automation.PSCredential -ArgumentList ($User, $Pass)

# -------------------------------------------
# License Configuration
# -------------------------------------------

$LicenseServer = $DDCServerNetBIOSName1
$LicenseServer_Port = "27000"
$LicenseServer_LicensingModel = "UserDevice"
$LicenseServer_ProductCode = "XDT"
$LicenseServer_ProductEdition = "PLT"
$LicenseServer_ProductVersion = "7.0"
$LicenseServer_AddressType = "WSL"

# Set Powershell Compatibility Mode
Set-StrictMode -Version 2.0

# Any failure is a terminating failure.
$ErrorActionPreference = 'Stop'

$logpath = "C:\cfn\log\citrix"

#create logging folder
mkdir $logpath -force

$logfile = join-path $logpath "initialize-site.log"
start-transcript -path $logfile -noclobber
$env:PSModulePath = $env:PSModulePath + ";C:\Program Files\Citrix\XenDesktopPoshSdk\Module\Citrix.XenDesktop.Admin.V1\"
# Add-PSSnapin Citrix.*
import-module -name Citrix.Xendesktop.Admin -Verbose
Add-PSSnapin Citrix.*
New-XDDatabase -AdminAddress $env:COMPUTERNAME -SiteName $XD7Site -DataStore Site -DatabaseServer $DatabaseServer -DatabaseName $DatabaseName_Site -DatabaseCredentials $Database_CredObject 
New-XDDatabase -AdminAddress $env:COMPUTERNAME -SiteName $XD7Site -DataStore Logging -DatabaseServer $DatabaseServer -DatabaseName $DatabaseName_Logging -DatabaseCredentials $Database_CredObject 
New-XDDatabase -AdminAddress $env:COMPUTERNAME -SiteName $XD7Site -DataStore Monitor -DatabaseServer $DatabaseServer -DatabaseName $DatabaseName_Monitor -DatabaseCredentials $Database_CredObject 

New-XDSite -AdminAddress $env:COMPUTERNAME -SiteName $XD7Site -DatabaseServer $DatabaseServer -LoggingDatabaseName $DatabaseName_Logging -MonitorDatabaseName $DatabaseName_Monitor -SiteDatabaseName $DatabaseName_Site 
#wtf licensing cmdlets missing from Citrix.Xendesktop.Admin

import-module .\Citrix.Configuration.PowerShellSnapIn.dll -verbose
import-module .\Citrix.LicensingAdmin.PowershellSnapIn.dll -verbose

Set-ConfigSite  -AdminAddress $env:COMPUTERNAME `
                -LicenseServerName $LicenseServer `
                -LicenseServerPort $LicenseServer_Port `
                -LicensingModel $LicenseServer_LicensingModel `
                -ProductCode $LicenseServer_ProductCode `
                -ProductEdition $LicenseServer_ProductEdition `
                -ProductVersion $LicenseServer_ProductVersion `

$LicenseServer_AdminAddress = Get-LicLocation -AddressType $LicenseServer_AddressType `
                                              -LicenseServerAddress $LicenseServer
                                              -LicenseServerPort $LicenseServer_Port

$LicenseServer_CertificateHash = $(Get-LicCertificate  -AdminAddress $LicenseServer_AdminAddress).CertHash
Set-ConfigSiteMetadata  -AdminAddress $env:COMPUTERNAME -Name "CertificateHash" -Value $LicenseServer_CertificateHash
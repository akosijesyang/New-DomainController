# Variables
$NewNetAdapterName = "Lab Network"
$NewInterfaceAlias = "Lab Network"
$HostIPAddress = "10.10.10.10"
$DefaultGateway = "10.10.10.1"
$DnsAddress1 = "10.10.10.10"
$DNSAddress2 = "10.10.10.20"

# Sets up network configurations
Write-Host 'Running build script part 1 of 3...' -ForegroundColor Yellow
Start-Sleep 2
Write-Host "Setting up network configurations..." -ForegroundColor Yellow
Start-Sleep 2
Get-NetAdapter | Rename-NetAdapter -NewName $NewNetAdapterName #Renames network adapter
Set-NetIPInterface -InterfaceAlias $NewInterfaceAlias -Dhcp Disabled # Disables dynamic IP configuration
New-NetIPAddress -IPAddress $HostIPAddress -DefaultGateway $DefaultGateway -PrefixLength 24 `
    -InterfaceAlias "Lab Network" # Sets IP address, Gateway, Subnet mask
Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6 #Disables IPv6
Set-DnsClientServerAddress -InterfaceAlias $NewInterfaceAlias `
    -ServerAddresses $DnsAddress1, $DNSAddress2 # Sets DNS servers

Write-Host "Installing ADDS, DHCP server roles..." -ForegroundColor Yellow
Start-Sleep 2
Install-WindowsFeature -Name AD-Domain-Services, DHCP `
    -IncludeManagementTools # Installs server roles

Write-Host "Renaming server..." -ForegroundColor Yellow
Start-Sleep 2
Rename-Computer -NewName "dcx" # Renames computer
Restart-Computer

# Nothing follows
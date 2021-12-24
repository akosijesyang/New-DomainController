# Variables
$NewInterfaceAlias = "Lab Network"
$DnsAddress1 = "10.10.10.10"
$DNSAddress2 = "10.10.10.20"
$DefaultGateway = "10.10.10.1"

# Double Tap - Setting DNS Servers
Set-DnsClientServerAddress -InterfaceAlias $NewInterfaceAlias `
    -ServerAddresses $DnsAddress1, $DNSAddress2 # Sets DNS servers

Write-Host 'Running build script part 3 of 3...' -ForegroundColor Yellow
Start-Sleep 2

# DNS
Write-Host "Finishing some additional DNS server settings..." -ForegroundColor Yellow
Start-Sleep 2
Add-DnsServerForwarder -IPAddress 8.8.8.8 -PassThru # Adds DNS server forwarder
Add-DnsServerPrimaryZone -NetworkID "10.10.10.0/24" -ReplicationScope "Domain" # Creates reverse lookup zone

# DHCP
Write-Host "Creating DHCP scope..." -ForegroundColor Yellow
Start-Sleep 2
Add-DhcpServerV4Scope -Name "ad.homelab.net" -StartRange 10.10.10.101 -EndRange 10.10.10.200 `
    -SubnetMask 255.255.255.0 # Creates scope
Set-DhcpServerV4OptionValue -DnsServer $DnsAddress1 -Router $DefaultGateway -ScopeID 10.10.10.0 # Sets DNS servers and gateway
Add-DhcpServerInDC -DnsName "dcx.ad.homelab.net" -IPAddress $DnsAddress1 # Authorizes DCHP server to provide IP address


Write-Host "Completed!" -ForegroundColor Yellow

# Nothing follows
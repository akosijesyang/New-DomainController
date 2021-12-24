# Variables
$NewInterfaceAlias = "Lab Network"
$DnsAddress1 = "10.10.10.10"
$DNSAddress2 = "10.10.10.20"

# Double Tap - Setting DNS Servers
Set-DnsClientServerAddress -InterfaceAlias $NewInterfaceAlias `
    -ServerAddresses $DnsAddress1, $DNSAddress2 # Sets DNS servers

Write-Host 'Running build script part 2 of 3...' -ForegroundColor Yellow
Start-Sleep 2
Write-Host "Creating AD forest root domain..." -ForegroundColor Yellow
Start-Sleep 2
Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" `
    -DomainName "ad.homelab.net" -DomainNetbiosName "AD" -ForestMode "WinThreshold" -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" -Force:$true # Configures forest root domain

# Nothing follows
If ("NET_172.100.17.0" -in (Get-VMSwitch | Select-Object -ExpandProperty Name) -eq $FALSE) {
    'Creating NAT switch "NET_172.100.17.0"'

    New-VMSwitch -Name "NET_172.100.17.0" -SwitchType NAT

    New-NetIPAddress -IPAddress 172.100.17.1 -PrefixLength 24 -InterfaceAlias "vEthernet (NET_172.100.17.0)"

    New-NetNAT -Name "NATNetwork" -InternalIPInterfaceAddressPrefix 172.100.17.0/24
}
else {
    '"NET_172.100.17.0" switch for static IP configuration already exists; skipping'
}

If ("172.100.17.1" -in (Get-NetIPAddress | Select-Object -ExpandProperty IPAddress) -eq $FALSE) {
    'Registering new IP address 172.100.17.1'

    New-NetIPAddress -IPAddress 172.100.17.1 -PrefixLength 24 -InterfaceAlias "vEthernet (NET_172.100.17.0)"
}
else {
    '"172.100.17.1" IP address for static IP configuration already registered; skipping'
}

If ("172.100.17.0/24" -in (Get-NetNAT | Select-Object -ExpandProperty InternalIPInterfaceAddressPrefix) -eq $FALSE) {
    'Registering new NAT adapter for 172.100.17.0/24'

    New-NetNAT -Name "NATNetwork" -InternalIPInterfaceAddressPrefix 172.100.17.0/24
}
else {
    '"172.100.17.0/24" NAT adapter for static IP configuration already registered; skipping'
}
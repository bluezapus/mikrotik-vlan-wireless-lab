# 2025-12-18 23:50:40 by RouterOS 7.20.6
# software id = 9NA9-A65A
#
# model = RB951Ui-2nD
# serial number = ED330F2E55AA
/interface ethernet
set [ find default-name=ether1 ] name="ether1 ISP"
set [ find default-name=ether2 ] name="ether2 TRUNK"
/interface vlan
add interface="ether2 TRUNK" name=vlan10-ADMIN vlan-id=10
add interface="ether2 TRUNK" name=vlan20-STAFF vlan-id=20
add interface="ether2 TRUNK" name=vlan30-GUEST vlan-id=30
add interface="ether2 TRUNK" name=vlan99-MGNT vlan-id=99
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
add name=hotspot supplicant-identity=""
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n disabled=no frequency=auto \
    mode=ap-bridge name=HOTSPOT security-profile=hotspot ssid=Hotspot
/ip hotspot profile
set [ find default=yes ] html-directory=hotspot
add dns-name=hotspot.local hotspot-address=192.168.100.1 html-directory=\
    flash/hotspot login-by=cookie,http-chap,http-pap name=hsprof1
/ip hotspot user profile
add name=profile_1 rate-limit=10M/10M
/ip pool
add name=dhcp_pool0 ranges=192.168.10.5-192.168.10.20
add name=dhcp_pool1 ranges=192.168.20.5-192.168.20.20
add name=dhcp_pool2 ranges=192.168.30.5-192.168.30.20
add name=dhcp_pool3 ranges=192.168.99.5-192.168.99.20
add name=dhcp_pool4 ranges=192.168.100.5-192.168.100.20
/ip dhcp-server
add address-pool=dhcp_pool0 interface=vlan10-ADMIN name=dhcp1
add address-pool=dhcp_pool1 interface=vlan20-STAFF name=dhcp2
add address-pool=dhcp_pool2 interface=vlan30-GUEST name=dhcp3
add address-pool=dhcp_pool3 interface=vlan99-MGNT name=dhcp4
# Interface not running
add address-pool=dhcp_pool4 interface=HOTSPOT name=dhcp5
/ip hotspot
add address-pool=dhcp_pool4 disabled=no interface=HOTSPOT name=hotspot1 \
    profile=hsprof1
/ip address
add address=192.168.10.1/24 comment="GW ADMIN" interface=vlan10-ADMIN \
    network=192.168.10.0
add address=192.168.20.1/24 comment="GW STAFF" interface=vlan20-STAFF \
    network=192.168.20.0
add address=192.168.30.1/24 comment="GW GUEST" interface=vlan30-GUEST \
    network=192.168.30.0
add address=192.168.99.1/24 comment="GW MGMT" interface=vlan99-MGNT network=\
    192.168.99.0
add address=192.168.100.1/24 comment=HOTSPOT interface=HOTSPOT network=\
    192.168.100.0
/ip dhcp-client
add interface="ether1 ISP"
/ip dhcp-server network
add address=192.168.10.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=192.168.10.1
add address=192.168.20.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=192.168.20.1
add address=192.168.30.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=192.168.30.1
add address=192.168.99.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=192.168.99.1
add address=192.168.100.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=192.168.100.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,1.1.1.1
/ip firewall filter
add action=drop chain=forward comment="Guest block admin" dst-address=\
    192.168.10.0/24 src-address=192.168.30.0/24
add action=drop chain=forward comment="Guest block Staff" dst-address=\
    192.168.20.0/24 src-address=192.168.30.0/24
add action=drop chain=forward comment="Guest block MGMT" dst-address=\
    192.168.99.0/24 src-address=192.168.30.0/24
add action=accept chain=forward disabled=yes out-interface="ether1 ISP"
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat out-interface="ether1 ISP"
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=192.168.100.0/24
/ip hotspot user
add name=user1 profile=profile_1 server=hotspot1
/ip service
set ftp disabled=yes
set telnet disabled=yes
set www disabled=yes
/system clock
set time-zone-name=Asia/Jakarta
/system identity
set name=MikroTik-RTR

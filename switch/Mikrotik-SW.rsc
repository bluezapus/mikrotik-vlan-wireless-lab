# 2025-12-03 13:53:33 by RouterOS 7.20.6
# software id = ICGU-FI1Z
#
# model = RB951Ui-2nD
# serial number = F11B0F5501B4
/interface bridge
add name=BR-VLAN vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] name=ether1-TRUNKING
set [ find default-name=ether2 ] name=ether2-ADMIN
set [ find default-name=ether3 ] name=ether3-STAFF
set [ find default-name=ether4 ] name=ether4-GUEST
/interface vlan
add interface=BR-VLAN name=VLAN99-MGMT vlan-id=99
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
add authentication-types=wpa-psk,wpa2-psk mode=dynamic-keys name=SEC-ADMIN \
    supplicant-identity=""
add authentication-types=wpa-psk,wpa2-psk mode=dynamic-keys name=SEC-STAFF \
    supplicant-identity=""
add name=SEC-GUEST supplicant-identity=""
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n disabled=no frequency=auto \
    installation=indoor mode=ap-bridge name=WLAN-ADMIN security-profile=\
    SEC-ADMIN ssid=OFFICE-ADMIN
add disabled=no mac-address=DE:2C:6E:31:7F:64 master-interface=WLAN-ADMIN \
    name=wlan1-STAFF security-profile=SEC-STAFF ssid=OFFICE-STAFF wps-mode=\
    disabled
add disabled=no mac-address=DE:2C:6E:31:7F:65 master-interface=WLAN-ADMIN \
    name=wlan2-GUEST security-profile=SEC-GUEST ssid=GUEST vlan-id=30 \
    wps-mode=disabled
/ip hotspot
add disabled=no interface=wlan2-GUEST name=server1
/ip hotspot profile
set [ find default=yes ] dns-name=hotspot.local hotspot-address=192.168.30.1 \
    login-by=cookie,http-chap,http-pap
/ip hotspot user profile
add name=profile-hotspot rate-limit=2M/2M shared-users=10
/ip pool
add name=hs-pool-12 ranges=192.168.30.5-192.168.30.20
add name=hs-pool-2 ranges=10.5.50.2-10.5.50.254
/interface bridge port
add bridge=BR-VLAN interface=ether1-TRUNKING
add bridge=BR-VLAN interface=ether2-ADMIN pvid=10
add bridge=BR-VLAN interface=ether3-STAFF pvid=20
add bridge=BR-VLAN interface=ether4-GUEST pvid=30
add bridge=BR-VLAN interface=WLAN-ADMIN pvid=10
add bridge=BR-VLAN interface=wlan1-STAFF pvid=20
add bridge=BR-VLAN interface=wlan2-GUEST pvid=30
/ip neighbor discovery-settings
set discover-interface-list=!dynamic
/interface bridge vlan
add bridge=BR-VLAN tagged=BR-VLAN,ether1-TRUNKING untagged=\
    ether2-ADMIN,WLAN-ADMIN vlan-ids=10
add bridge=BR-VLAN tagged=BR-VLAN,ether1-TRUNKING untagged=\
    ether3-STAFF,wlan1-STAFF vlan-ids=20
add bridge=BR-VLAN tagged=BR-VLAN,ether1-TRUNKING untagged=\
    ether4-GUEST,wlan2-GUEST vlan-ids=30
add bridge=BR-VLAN tagged=BR-VLAN,ether1-TRUNKING vlan-ids=99
/ip address
add address=192.168.99.2/24 comment="Mgmt SW-AP" interface=VLAN99-MGMT \
    network=192.168.99.0
add address=192.168.30.1/24 comment="hotspot network" interface=wlan2-GUEST \
    network=192.168.30.0
add address=10.5.50.1/24 comment="hotspot network" interface=WLAN-ADMIN \
    network=10.5.50.0
add address=10.5.50.1/24 comment="hotspot network" interface=wlan2-GUEST \
    network=10.5.50.0
/ip dhcp-server
# DHCP server can not run on slave interface!
add address-pool=hs-pool-12 interface=wlan2-GUEST name=dhcp1
# DHCP server can not run on slave interface!
add address-pool=hs-pool-2 interface=WLAN-ADMIN name=dhcp2
/ip dhcp-server network
add address=10.5.50.0/24 comment="hotspot network" gateway=10.5.50.1
add address=192.168.30.0/24 comment="hotspot network" gateway=192.168.30.1
/ip firewall nat
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=192.168.30.0/24
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=10.5.50.0/24
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=10.5.50.0/24
/ip hotspot user
add name=admin profile=profile-hotspot
/ip route
add disabled=no dst-address=0.0.0.0/0 gateway=192.168.99.1 routing-table=main \
    suppress-hw-offload=no
/system identity
set name=MikroTik-SW

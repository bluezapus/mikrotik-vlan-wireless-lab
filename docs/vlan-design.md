# VLAN Design & Network Segmentation

This document describes the VLAN design implemented in the **MikroTik Enterprise VLAN & Wireless** network lab.

The primary objectives of the VLAN implementation are:
- Network segmentation
- Enhanced security
- Simplified management
- Network scalability
---
## 1. VLAN List

| VLAN ID | VLAN Name | Function                          |
|--------:|-----------|-----------------------------------|
| 10      | ADMIN     | Administrator and management access |
| 20      | STAFF     | Internal employee network access    |
| 30      | GUEST     | Guest / public access               |
| 99      | MGMT      | Network device management           |

---
## 2. VLAN Architecture

The network design follows a **router-on-a-stick** approach:
- VLAN tagging is implemented on the trunk link
- Inter-VLAN routing is handled by the core router
- The access switch operates strictly as a Layer 2 device

---
## 3. MikroTik-SW: Trunk and Access Ports

### Trunk Port
The trunk port carries multiple VLANs between the core router and the access switch.

- Interface: `ether1-TRUNK`
- Allowed VLANs: 10, 20, 30, 99
- Mode: Tagged

### Access Ports
Access ports are assigned to endpoint devices.

| Interface | VLAN | Mode   |
|-----------|-----:|--------|
| ether2    | 10   | Access |
| ether3    | 20   | Access |
| ether4    | 30   | Access |

---
## 4. Wireless VLAN Mapping

Wireless SSIDs are directly mapped to VLANs using bridge VLAN filtering.

| SSID         | VLAN ID | Type            |
|--------------|--------:|-----------------|
| WLAN-ADMIN   | 10      | Secure (WPA2)   |
| WLAN-STAFF   | 20      | Secure (WPA2)   |
| WLAN-GUEST   | 30      | Open            |

---

## 5. Inter-VLAN Routing Policy

Inter-VLAN routing policies are defined as follows:
- **ADMIN VLAN** → Full network access
- **STAFF VLAN** → Internet access and internal services
- **GUEST VLAN** → Internet access only

Routing control is enforced using firewall filter rules on the core router.

---
## 6. Guest VLAN Security

Security policies applied to the Guest VLAN include:
- No access to ADMIN and OFFICE VLANs
- No access to router management services
- All user access controlled via Hotspot authentication
- NAT and firewall rules enforced at the gateway
---
## 7. Design Considerations
- VLAN IDs are assigned sequentially for clarity and ease of management
- The design allows for the addition of new VLANs without major architectural changes
- Clear separation of Layer 2 and Layer 3 functions follows enterprise networking best ractices

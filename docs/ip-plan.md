# IP Addressing Plan

This document describes the IP addressing scheme used in the **MikroTik Enterprise VLAN & Wireless** network lab.

The IP design follows these principles:
- One subnet per VLAN
- Default gateways located on the **MikroTik-RTR**
- Readable, structured, and scalable IP allocation
---
## 1. IP Address Summary

| VLAN ID | VLAN Name | Subnet            | Gateway        |
|--------:|-----------|-------------------|----------------|
| 10      | ADMIN     | 192.168.10.0/24   | 192.168.10.1  |
| 20      | STAFF     | 192.168.20.0/24   | 192.168.20.1  |
| 30      | GUEST     | 192.168.30.0/24   | 192.168.30.1  |

---
## 2. Gateway IP Allocation
The default gateway for each VLAN is assigned on the **MikroTik-RTR** using Layer 3 VLAN interfaces.

| Device          | Interface      | IP Address        |
|-----------------|----------------|-------------------|
| MikroTik-RTR-01 | VLAN10-ADMIN   | 192.168.10.1/24  |
| MikroTik-RTR-01 | VLAN20-OFFICE  | 192.168.20.1/24  |
| MikroTik-RTR-01 | VLAN30-GUEST   | 192.168.30.1/24  |

---
## 3. DHCP Address Pools
Each VLAN is configured with a dedicated DHCP server to ensure network isolation and effective traffic control.

| VLAN  | DHCP Range                   |
|------:|------------------------------|
| ADMIN | 192.168.10.5 – 192.168.10.20 |
| STAFF | 192.168.20.5 – 192.168.20.20 |
| GUEST | 192.168.30.5 – 192.168.30.20 |

---
## 4. DNS Configuration
DNS services are centrally configured on the router and distributed to all clients via DHCP.

- Primary DNS: `8.8.8.8`
- Secondary DNS: `1.1.1.1`
- Allow Remote Requests: Enabled
---
## 5. Design Notes
- Unused IP address ranges are reserved for network infrastructure devices such as outers, switches, and access points.
- DHCP pools are defined conservatively to allow future expansio

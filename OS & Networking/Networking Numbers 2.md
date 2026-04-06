Here’s a **quick mind-map / cheat sheet** of networking numbers to remember for IPs, subnets, bits, and related calculations. Perfect for last-minute revision.

---

## 1. IPv4 Address Basics
| Item | Value |
|------|-------|
| IPv4 address size | **32 bits** |
| IPv4 dotted decimal | 4 octets (each 8 bits) |
| IPv6 address size | **128 bits** |
| Max IPv4 addresses | ~4.3 billion |

---

## 2. Classful Addressing (Remember the first octet ranges)
| Class         | Start | End | Default Mask        | Network bits | Host bits |
| ------------- | ----- | --- | ------------------- | ------------ | --------- |
| A             | 0     | 127 | /8 (255.0.0.0)      | 8            | 24        |
| B             | 128   | 191 | /16 (255.255.0.0)   | 16           | 16        |
| C             | 192   | 223 | /24 (255.255.255.0) | 24           | 8         |
| D (multicast) | 224   | 239 | –                   | –            | –         |
| E (reserved)  | 240   | 255 | –                   | –            | –         |

> **Loopback**: 127.0.0.0/8 (mostly 127.0.0.1)

---

## 3. Private IP Ranges (RFC 1918)
| Class | Range | CIDR | Subnet Mask |
|-------|-------|------|--------------|
| A | 10.0.0.0 – 10.255.255.255 | 10.0.0.0/8 | 255.0.0.0 |
| B | 172.16.0.0 – 172.31.255.255 | 172.16.0.0/12 | 255.240.0.0 |
| C | 192.168.0.0 – 192.168.255.255 | 192.168.0.0/16 | 255.255.0.0 |

> **APIPA** (when DHCP fails): 169.254.0.0/16

---

## 4. Subnet Mask Quick Table (CIDR to Dotted Decimal)
| CIDR | Mask | # of IPs | # of Hosts (usable) |
|------|------|----------|----------------------|
| /8 | 255.0.0.0 | 16.7M | 16,777,214 |
| /16 | 255.255.0.0 | 65,536 | 65,534 |
| /24 | 255.255.255.0 | 256 | 254 |
| /25 | 255.255.255.128 | 128 | 126 |
| /26 | 255.255.255.192 | 64 | 62 |
| /27 | 255.255.255.224 | 32 | 30 |
| /28 | 255.255.255.240 | 16 | 14 |
| /29 | 255.255.255.248 | 8 | 6 |
| /30 | 255.255.255.252 | 4 | 2 (point-to-point links) |
| /31 | 255.255.255.254 | 2 | 2 (no broadcast, RFC 3021) |
| /32 | 255.255.255.255 | 1 | 1 (host route) |

> **Formula**: Usable hosts = 2^(32 – CIDR) – 2  
> Subtract 2 for network address and broadcast address.

---

## 5. Wildcard Masks (for ACLs)
Wildcard mask = 255.255.255.255 – Subnet mask

| Subnet Mask | Wildcard Mask |
|-------------|----------------|
| 255.0.0.0 | 0.255.255.255 |
| 255.255.0.0 | 0.0.255.255 |
| 255.255.255.0 | 0.0.0.255 |
| 255.255.255.248 | 0.0.0.7 |

---

## 6. Important Protocol & Port Numbers
| Protocol | Port | Transport |
|----------|------|------------|
| FTP data | 20 | TCP |
| FTP control | 21 | TCP |
| SSH | 22 | TCP |
| Telnet | 23 | TCP |
| SMTP | 25 | TCP |
| DNS | 53 | UDP/TCP |
| DHCP (server) | 67 | UDP |
| DHCP (client) | 68 | UDP |
| HTTP | 80 | TCP |
| POP3 | 110 | TCP |
| NTP | 123 | UDP |
| IMAP | 143 | TCP |
| SNMP | 161 | UDP |
| HTTPS | 443 | TCP |

---

## 7. Ethernet & MTU
| Item | Value |
|------|-------|
| Ethernet MTU | 1500 bytes |
| Minimum Ethernet frame size | 64 bytes |
| Maximum Ethernet frame size | 1518 bytes (including header) |
| IPv4 minimum MTU | 576 bytes (must support) |
| IPv6 minimum MTU | 1280 bytes |

---

## 8. TCP/UDP Headers (Important for calculations)
| Header | Size |
|--------|------|
| TCP header (without options) | 20 bytes |
| UDP header | 8 bytes |
| IPv4 header (without options) | 20 bytes |
| IPv6 header | 40 bytes |
| Ethernet header | 14 bytes |
| Ethernet trailer (FCS) | 4 bytes |

---

## 9. Useful Powers of 2 (for subnetting)
| 2^n | Value |
|-----|-------|
| 2^3 | 8 |
| 2^4 | 16 |
| 2^5 | 32 |
| 2^6 | 64 |
| 2^7 | 128 |
| 2^8 | 256 |
| 2^10 | 1024 |
| 2^16 | 65536 |

> **Block size** = 256 – last non-zero octet in mask  
> Example: 255.255.255.192 → block size = 256 – 192 = 64

---

## 10. Quick Subnetting Steps (Mental Math)
1. **Find network ID**: IP & Mask (bitwise AND)
2. **Find broadcast**: Network ID + (block size – 1)
3. **First usable host**: Network ID + 1
4. **Last usable host**: Broadcast – 1
5. **Number of subnets** = 2^(borrowed bits)
6. **Number of hosts per subnet** = 2^(remaining host bits) – 2

---

## 11. IPv6 Shortcuts
| Type | Prefix |
|------|--------|
| Global unicast | 2000::/3 |
| Link-local | FE80::/10 |
| Unique local (private) | FC00::/7 |
| Multicast | FF00::/8 |
| Loopback | ::1 |

> IPv6 has **no broadcast** (uses multicast)

---

## 12. Time-to-Live (TTL) Defaults
| OS | Default TTL |
|----|--------------|
| Windows | 128 |
| Linux/Unix | 64 |
| Cisco routers | 255 |

---

Quick mental picture for subnet mask:
- **/24** → 255.255.255.0 → block 256 → 254 hosts
- **/25** → 255.255.255.128 → block 128 → 126 hosts
- **/26** → 255.255.255.192 → block 64 → 62 hosts
- **/27** → 255.255.255.224 → block 32 → 30 hosts
- **/28** → 255.255.255.240 → block 16 → 14 hosts
- **/29** → 255.255.255.248 → block 8 → 6 hosts
- **/30** → 255.255.255.252 → block 4 → 2 hosts

---

Good luck tomorrow! This sheet covers ~90% of numerical problems.
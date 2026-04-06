Here is the **OSI Model** (Open Systems Interconnection) with all 7 layers and their **main, exam-recognized functions**.

> Mnemonic to remember order (bottom to top): **Please Do Not Throw Sausage Pizza Away**  
> (Physical → Data Link → Network → Transport → Session → Presentation → Application)

---

## Layer 1 – Physical
**Main functions recognized by:**
- **Bits** (0s and 1s) transmission over physical medium
- Defines **cables, connectors, voltage levels, data rates**
- **Topology** (bus, star, ring)
- **Synchronization** of bits

> Key phrase: *“Transmits raw bits over a physical medium”*

---

## Layer 2 – Data Link
**Main functions recognized by:**
- **Frames** (encapsulates packets into frames)
- **MAC addresses** (hardware addressing)
- **Error detection** (CRC) and **error correction** (retransmission)
- **Flow control** between directly connected nodes
- **Access control** (CSMA/CD, CSMA/CA – for Ethernet/WiFi)
- **Switching** (layer 2 switches operate here)

> Key phrase: *“Hop-to-hop delivery using MAC addresses”*

---

## Layer 3 – Network
**Main functions recognized by:**
- **Packets** (encapsulates segments into packets)
- **Logical addressing** (IP addresses – IPv4, IPv6)
- **Routing** (determines best path – routers work here)
- **Fragmentation & reassembly** (if packet > MTU)
- **Congestion control** (simple – e.g., dropping packets)

> Key phrase: *“End-to-end logical addressing and routing”*

---

## Layer 4 – Transport
**Main functions recognized by:**
- **Segments** (TCP) or **Datagrams** (UDP)
- **Port numbers** (multiplexing/demultiplexing)
- **Reliability** (TCP: ACKs, retransmissions, sequencing)
- **Flow control** (sliding window, TCP window size)
- **Congestion control** (TCP: AIMD, slow start, fast retransmit)
- **Error recovery** (retransmission of lost segments)

> Key phrase: *“End-to-end connection, reliability, and port-based delivery”*

---

## Layer 5 – Session
**Main functions recognized by:**
- **Session establishment, maintenance, and termination**
- **Dialog control** (who speaks when – half-duplex/full-duplex)
- **Synchronization points** (checkpoints for long transfers)
- **Session recovery** (resume after failure)

> Key phrase: *“Manages conversation between applications”*

---

## Layer 6 – Presentation
**Main functions recognized by:**
- **Translation** (data format conversion – ASCII to EBCDIC, etc.)
- **Encryption/Decryption** (SSL/TLS partly here in theory)
- **Compression** (data size reduction)
- **Serialization** (structure to byte stream)

> Key phrase: *“Data formatting, encryption, and compression”*

---

## Layer 7 – Application
**Main functions recognized by:**
- **User interface** (where applications interact with network)
- **Protocols** like HTTP, FTP, SMTP, DNS, Telnet, SSH
- **Message** (PDU – Protocol Data Unit)
- **Authentication** and **service location**

> Key phrase: *“Provides network services to user applications”*

---

## Quick Reference Table (Exam Ready)

| Layer | PDU (Data Unit) | Key Device | Key Addressing | Main Keyword |
|-------|----------------|------------|----------------|---------------|
| 7 – Application | Message | Gateway | – | User services |
| 6 – Presentation | Message | Gateway | – | Format/Encrypt/Compress |
| 5 – Session | Message | Gateway | – | Dialog control |
| 4 – Transport | Segment (TCP) / Datagram (UDP) | – | Port number | Reliability |
| 3 – Network | Packet | Router | IP address | Routing |
| 2 – Data Link | Frame | Switch | MAC address | Hop-to-hop |
| 1 – Physical | Bit | Hub, Repeater | – | Raw bits |

---

## Common Exam Trick Questions

| Statement | Which layer? |
|-----------|---------------|
| “Converts ASCII to EBCDIC” | Presentation |
| “Manages TCP 3-way handshake” | Transport |
| “Finds best path using OSPF” | Network |
| “Adds a trailer for CRC” | Data Link |
| “Uses port 80” | Application |
| “Resumes a file download from last checkpoint” | Session |
| “Defines voltage for 0 and 1” | Physical |

---

Good luck tomorrow! This is the exact breakdown most exams expect.
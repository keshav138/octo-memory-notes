Consider a concrete example: you open your browser and fetch a secure web page with **`GET (https://example.com/index.html)`**.

  

As this request travels down the stack on your machine, each layer wraps the payload with its own protocol metadata—a process called **encapsulation**.

  

### The Outbound Request (Sender: Encapsulation)

**7. Application Layer (HTTP / TLS / DNS)**

  

- **Protocol Data Unit (PDU):** Data / Message
    
      
    
- **What happens:** The browser formats the actual human/application intent into raw application data: `GET /index.html HTTP/1.1\r\nHost: example.com...`.
    
      
    

**6. Presentation Layer**

  

- **What happens:** Formats, serializes, and secures the data representation. In modern web architectures, this is where **TLS/SSL encryption** encrypts the HTTP plaintext into ciphertext before transmission, along with standard data serialization or compression (e.g., gzip).
    
      
    

**5. Session Layer**

  

- **What happens:** Manages dialogue control and connection state (opening, synchronizing checkpoints, and closing communication channels). In practice across the modern TCP/IP stack, Layers 5–7 run together inside user-space application code and TLS libraries.
    
      
    

**4. Transport Layer (TCP)**

  

- **PDU:** Segment
    
      
    
- **What happens:** Adds the **TCP Header**. It attaches:
    
      
    - Source Port (ephemeral, e.g., `54321`) and Destination Port (`443` for HTTPS).
        
          
        
    - Sequence and Acknowledgment numbers for reliable in-order delivery.
        
          
        
    - Window size for flow control.
        
          
        
    - Splits the stream into smaller segments if the data exceeds the Maximum Segment Size (MSS).
        
          
        

**3. Network Layer (IP)**

  

- **PDU:** Packet
    
      
    
- **What happens:** Wraps the TCP segment inside an **IPv4/IPv6 Header**. It attaches:
    
      
    - Source IP (your client's IP, e.g., `192.168.1.50`).
        
          
        
    - Destination IP (the resolved web server's public IP).
        
          
        
    - Time to Live (**TTL**) to prevent infinite routing loops.
        
          
        
    - Determines the next-hop routing path via the local routing table.
        
          
        

**2. Data Link Layer (Ethernet / Wi-Fi)**

  

- **PDU:** Frame
    
      
    
- **What happens:** Wraps the IP packet with an **Ethernet Header** and a **Frame Check Sequence (FCS) Trailer**. It attaches:
    
      
    - Source MAC Address (your local network card).
        
          
        
    - Destination MAC Address (your local default gateway/router, resolved using **ARP**).
        
          
        
    - Appends a Cyclic Redundancy Check (**CRC**) trailer to detect bit-level corruption during physical transmission.
        
          
        

**1. Physical Layer**

  

- **PDU:** Bits / Signals
    
      
    
- **What happens:** The network interface card (NIC) converts raw binary `1`s and `0`s into physical transmission signals: electrical pulses (Ethernet copper wire), radio frequencies (Wi-Fi), or light pulses (fiber-optic cable).
    
      
    

### The Inbound Request (Receiver: Decapsulation)

When the server (or target web server) receives the physical transmission, the exact reverse occurs (**decapsulation**):

  

```
[Layer 1: Physical]     Receives signal, decodes bits into raw bytes.
         ▼
[Layer 2: Data Link]    Validates CRC checksum. Strips Ethernet MAC header.
         ▼
[Layer 3: Network]      Verifies Destination IP matches server. Decrements TTL. Strips IP header.
         ▼
[Layer 4: Transport]    Reassembles out-of-order segments. Routes to Port 443. Strips TCP header.
         ▼
[Layers 5-7: App]       Decrypts TLS payload. Web server (Nginx/Apache) parses `GET /index.html`.
```

### 15-Second Interview Summary

> "Each layer adds an address and a control contract for its peer on the remote machine. Layer 4 adds **port numbers and sequence controls** (Segments) to identify the process; Layer 3 adds **logical IP addresses** (Packets) for end-to-end host routing; Layer 2 adds **physical MAC addresses and checksums** (Frames) for local hop-to-hop delivery; and Layer 1 converts those framed bytes into **physical signals** on the wire."
When you're dealing with networking, everything revolves around the **Power of 2**. Here is a "mental cheat sheet" organized by category to help you internalize the numbers quickly.

---

## 1. The Magic Octet (Bits to Decimals)

Since an IP address has 4 octets of 8 bits each, you need to know what each bit is worth.

|**Bit Position**|**8**|**7**|**6**|**5**|**4**|**3**|**2**|**1**|
|---|---|---|---|---|---|---|---|---|
|**Value**|**128**|**64**|**32**|**16**|**8**|**4**|**2**|**1**|

- **Total sum of 8 bits:** 255.
    
- **Total combinations:** 256 ($2^8$).
    

---

## 2. Subnet Mask "Cheat Ladder"

This is the most common "mind map" used for CIDR notation.

- **/24** = 255.255.255.0 (256 IPs)
    
- **/25** = 255.255.255.128 (128 IPs)
    
- **/26** = 255.255.255.192 (64 IPs)
    
- **/27** = 255.255.255.224 (32 IPs)
    
- **/28** = 255.255.255.240 (16 IPs)
    
- **/29** = 255.255.255.248 (8 IPs)
    
- **/30** = 255.255.255.252 (4 IPs — used for point-to-point links)
    

---

## 3. The Formulas to Remember

If you have these two formulas, you can solve almost any subnetting problem:

- **Number of Subnets:** $2^n$ (where $n$ = number of borrowed bits).
    
- **Number of Hosts:** $2^h - 2$ (where $h$ = number of host bits remaining).
    
    > _Why -2? One for the **Network ID** and one for the **Broadcast Address**._
    

---

## 4. IP Address Classes (The Basics)

|**Class**|**Range (First Octet)**|**Default Mask**|
|---|---|---|
|**A**|1 – 126|255.0.0.0 (/8)|
|**B**|128 – 191|255.255.0.0 (/16)|
|**C**|192 – 223|255.255.255.0 (/24)|
|**Loopback**|127.0.0.1|(Internal testing)|

---

## 5. Private IP Ranges (Non-Routable)

These are the IPs used inside homes and offices that don't go on the public internet.

- **Class A:** 10.0.0.0 to 10.255.255.255
    
- **Class B:** 172.16.0.0 to 172.31.255.255
    
- **Class C:** 192.168.0.0 to 192.168.255.255
    

---

### Pro-Tip: The "256 Rule"

To find the increment (the "block size") of your subnets, subtract the last non-zero octet of the mask from 256.

- **Example:** For a **/26** mask (255.255.255.**192**):
    
    - $256 - 192 = 64$.
        
    - Your networks start at .0, .64, .128, .192.
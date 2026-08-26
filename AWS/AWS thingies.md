Sure — here's the "why" behind each piece, in the order you'll build them.

**VPC (`demo-vpc`)** A VPC is your own isolated network inside AWS — a private address space (`10.0.0.0/16`) that nothing outside it can see unless you explicitly open a path. Every EC2 instance has to live inside some VPC; you're building a dedicated one instead of using the account's default so you have full control over its networking.

**Subnet (`demo-public-subnet`, `10.0.1.0/24`)** A VPC is just an address range — you can't launch instances directly into it, you carve it into subnets first. This one is called "public" because you'll route it to the internet (next step) and auto-assign it public IPs. A subnet also pins your instance to a specific Availability Zone.

**Internet Gateway (`demo-igw`)** By default, a VPC is completely sealed off — no internet in or out. The IGW is the literal door between your VPC and the internet. Creating it isn't enough on its own — it has to be attached to the VPC and something has to know traffic should be sent through it, which is what the route table is for.

**Route Table (`demo-public-rt`)** This is the "directions" for traffic leaving the subnet. The rule `0.0.0.0/0 → demo-igw` means "any traffic not meant for something inside this VPC, send it out through the internet gateway." Without this, the IGW exists but nothing uses it — your subnet would still be unreachable. Associating the route table with `demo-public-subnet` is what makes that subnet "public" in practice.

**Security Groups (`ssh-web-sg`, `rdp-sg`)** Think of these as a stateful firewall attached to the instance itself (not the subnet). Even with a full route to the internet, nothing can reach your instance unless a security group rule explicitly allows that port. You're using two separate groups because the two instances need different inbound ports open (22 for SSH, 3389 for RDP) — no reason to expose RDP on the Linux box or SSH on the Windows one.

**Key Pairs (`ubuntu-key`, `windows-key`)** AWS instances don't use a traditional password login by default — they use public/private key cryptography. AWS stores the _public_ key on the instance at launch; you keep the _private_ key (`.pem`).

- On Linux, SSH uses the private key directly to prove who you are — no password ever exists.
- On Windows, EC2 actually does generate a random Administrator password, but it's encrypted — the private key is only used once, to decrypt and reveal that password, which you then use for the actual RDP login.

**Why SSH and RDP behave differently** SSH is the native remote-access protocol for Linux — key-based, no password step. RDP is Windows' native protocol, and it fundamentally expects a username+password, so AWS bridges the gap by generating that password and letting your key unlock it just once.

**Why the Fleet Manager fallback exists (C6)** Direct RDP (`mstsc`) requires port 3389 to be reachable from your IP and nothing in between blocking it (corporate firewall, ISP blocking, changed public IP, etc.). Systems Manager Fleet Manager instead tunnels the RDP session through AWS's own infrastructure using an agent on the instance (needs the `AmazonSSMManagedInstanceCore` role) — so it works even when a direct network path doesn't, at the cost of a bit more setup.

That's the full causal chain: VPC → subnet → IGW → route table gets you _reachability_; security groups gets you _permission_; key pairs gets you _identity/authentication_.
# 🌐 Layer 4 Load Balancer (Transport Layer)

## 🧠 Works at:

**Transport layer (TCP/UDP)**

## 🔹 What it sees:

- IP address
    
- Port number
    

👉 It **does NOT look inside the request**

---

## ⚙️ How it works

It forwards traffic like:

```id="s2q9g3"
Client → LB → Server
(based on IP + Port)
```

Example decision:

- Send traffic on port 80 → Server A
    
- Send traffic on port 443 → Server B
    

---

## 🚀 Key properties

- Very fast ⚡
    
- Low latency
    
- No understanding of HTTP, JSON, etc.
    

---

## 🧩 Example tools

- AWS NLB
    
- HAProxy (TCP mode)
    

---

# 🌍 Layer 7 Load Balancer (Application Layer)

## 🧠 Works at:

**Application layer (HTTP/HTTPS)**

## 🔹 What it sees:

- URL path (`/api/users`)
    
- Headers
    
- Cookies
    
- Request body (sometimes)
    

---

## ⚙️ How it works

```id="6j3trt"
Client → LB → Server
(based on request content)
```

Example decisions:

```id="xv1dj7"
/api/users → Server A
/api/payments → Server B
```

---

## 🚀 Key properties

- Smarter routing 🧠
    
- Can inspect requests
    
- Slightly slower than L4
    

---

## 🧩 Example tools

- Nginx
    
- AWS ALB
    
- Envoy
    

---

# ⚔️ L4 vs L7 (Core Difference)

|Feature|Layer 4|Layer 7|
|---|---|---|
|Layer|Transport|Application|
|Data visibility|❌ Cannot see content|✅ Can inspect content|
|Routing|IP + Port|URL, headers, cookies|
|Speed|⚡ Faster|Slightly slower|
|Use case|Raw traffic routing|Smart routing|

---

# 🔥 Real-world intuition

## 🟦 L4 Load Balancer

> “I don’t care what’s inside — just forward traffic fast.”

---

## 🟩 L7 Load Balancer

> “Let me read the request and make smart decisions.”

---

# 🎯 Example (this makes it click)

### Incoming requests:

```
GET /login
GET /products
GET /payments
```

---

### L4 behavior:

```
→ randomly distribute to servers
```

---

### L7 behavior:

```
/login → Auth service
/products → Product service
/payments → Payment service
```

---

# ⚡ Final intuition

- **L4 = network-level routing**
    
- **L7 = application-aware routing**
    

---

If you want to go deeper (and you should for interviews), I can show:

- How load balancers work with **TLS termination**
    
- Sticky sessions vs stateless routing
    
- Where **API Gateways fit vs L7 LB**
    

Just tell me 👍
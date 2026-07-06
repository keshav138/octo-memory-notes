When you aren't running an MCP server locally via `stdio`, the primary alternative is **HTTP-based transport** [1.1.1, 1.3.2].

This allows MCP servers to be hosted remotely (e.g., in the cloud or on a centralized server) and accessed by AI clients over a network [1.1.1, 1.3.1]. There are two main ways this is implemented:

### 1. Streamable HTTP (The Modern Standard)

Introduced in early 2025, **Streamable HTTP** is now the recommended standard for all new remote MCP server developments [1.1.1, 1.3.2].

- **How it works:** The server exposes a **single HTTP endpoint** (e.g., `/mcp`) that handles all communication [1.1.1, 1.3.2].
    
- **The Workflow:**
    
    - **POST Requests:** The client sends commands or tool requests to this endpoint using HTTP POST [1.1.1, 1.3.2].
        
    - **GET Requests & SSE:** The client can initiate a GET request to establish a persistent stream (using **Server-Sent Events** or SSE) [1.1.1, 1.3.2]. This allows the server to "push" updates, notifications, or streaming responses back to the client in real-time [1.1.1, 1.3.2].
        
- **Why it’s better:** It is more flexible and efficient than older methods, supporting both simple request-response interactions and complex, real-time streaming over a single URL [1.1.1, 1.3.2].
    

### 2. HTTP + SSE (The Legacy Method)

Before Streamable HTTP became the standard, MCP used a two-channel approach based on HTTP and Server-Sent Events (SSE) [1.1.1, 1.3.2]. While still supported for backward compatibility, it is being phased out in favor of the unified Streamable HTTP approach [1.1.1].

- **How it worked:** It utilized two distinct endpoints:
    
    - **A GET endpoint (`/events`):** Used strictly for the server to send updates to the client via an SSE stream [1.1.1].
        
    - **A POST endpoint (`/message`):** Used strictly for the client to send requests to the server [1.1.1].
        
- **Why it was replaced:** Managing two separate endpoints was less flexible and harder to implement than the modern single-endpoint design [1.1.1, 1.3.2].
    

### Summary Comparison

|**Feature**|**stdio (Local)**|**Streamable HTTP (Remote/Network)**|
|---|---|---|
|**Connectivity**|Local subprocess (same machine)|Over network (HTTP/HTTPS)|
|**Scalability**|Single client|Multiple concurrent clients|
|**Complexity**|Simple|More complex (requires HTTP server)|
|**Use Case**|Local tools, quick scripts|Cloud services, team-shared tools|

In short, if you are building a tool that needs to be accessed by multiple people or hosted on a cloud server, you should use **Streamable HTTP** [1.1.1, 1.2.3].****
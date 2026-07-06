The **Model Context Protocol (MCP)** is an open standard designed to simplify how AI models—like those inside IDEs or chat applications—connect to external tools, data, and services [1.1.1, 1.1.3, 1.1.5].

Before MCP, if you wanted an AI agent to access five different tools (like a database, a file system, and a CRM), you had to build five custom integrations for that specific agent [1.1.5]. If you then switched to a different AI application, you had to rebuild them all over again [1.1.5]. MCP solves this by standardizing the connection, acting like a "USB-C port" for AI: you build the integration once, and it works with any MCP-compatible AI host [1.1.5].

### How MCP Works

The architecture consists of three main parts [1.1.3]:

1. **MCP Host:** The AI application you are using (e.g., Claude Desktop, an IDE, or a custom agent) [1.1.3].
    
2. **MCP Server:** The "bridge" that connects to your specific data or tool (e.g., a server that talks to your local filesystem or a Postgres database) [1.1.3].
    
3. **Transport Layer:** The communication channel (JSON-RPC) between the Host and the Server [1.1.3, 1.2.3].
    

### Working with `stdio` as a Local Subprocess

When running MCP locally, the most common way to connect the Host to the Server is via **`stdio` (Standard Input/Output)** [1.2.1, 1.2.3].

In this setup, the Host acts as the parent process and the MCP Server acts as a **local subprocess** [1.2.1, 1.2.3].

#### The Mechanics:

- **Process Launch:** The Host launches your MCP server script (e.g., a Python or Node.js file) as a child process [1.2.2, 1.2.3].
    
- **Communication:**
    
    - The Host writes JSON-RPC requests to the server's `stdin` (Standard Input) [1.2.2, 1.2.3].
        
    - The server reads these requests, performs the action, and writes its responses back to its `stdout` (Standard Output) [1.2.2, 1.2.3].
        
- **Separation:** Any logs or diagnostics the server needs to output are sent to `stderr` (Standard Error) [1.2.3]. This is critical: **`stdout` must be reserved strictly for the protocol messages** [1.2.3]. If the server prints "Hello World" or a debug message to `stdout`, it will corrupt the JSON stream and break the connection [1.2.3].
    

#### Why use `stdio`?

- **No Networking Overhead:** Since everything happens on your local machine using process pipes, there are no ports to open, no TLS certificates to manage, and no network latency [1.2.2, 1.2.3].
    
- **Speed:** Startup and message exchange happen at process-execution speeds, making it ideal for rapid local development and debugging [1.2.2].
    
- **Lifecycle Coupling:** The server process typically exists only for the lifetime of that specific client session [1.2.2, 1.2.4]. When the Host closes, it closes the `stdin` pipe, signaling the server to shut down gracefully [1.2.3].
    

This `stdio` approach is the default for tools like Claude Desktop, allowing you to add new capabilities to your AI assistant simply by pointing the configuration file to a local script [1.2.1, 1.2.3].
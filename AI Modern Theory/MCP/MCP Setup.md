To set up an MCP (Model Context Protocol) server, the user primarily needs to **configure an MCP client** to recognize and communicate with the server. Whether you are using a local script or a remote URL, the process generally involves editing a JSON-based configuration file.

### 1. What the User Needs to Configure

The user does not necessarily need to "code" a new server from scratch; often, they are simply connecting an existing one. The core configuration involves providing the client with the server's details.

- **Server Name:** A unique label for the server (e.g., `weather`, `figma-desktop`, `atlassian`).
    
- **Connection Method (Transport):**
    
    - **For Local Servers (`stdio`):** You must provide the **command** to run the server. The client will execute this command as a subprocess. For example, if you are using Node.js or Python, you provide the command (like `node` or `python`) and the arguments (like the path to your server script or an `npx` command).
        
    - **For Remote Servers (`http`):** You must provide the **URL** where the server is hosted.
        
- **Environment Variables & Authentication:** If the server requires API keys, OAuth tokens, or specific environment variables (like a database connection string), these are also added to the configuration file.
    

### 2. The Configuration File

Most MCP clients (like Claude Desktop, VS Code, or Cursor) use a standard JSON configuration file. You generally need to add your server to the `mcpServers` block.

**Example Configuration (`mcp.json` or `claude_desktop_config.json`):**

JSON

```
{
  "mcpServers": {
    "my-local-server": {
      "command": "node",
      "args": ["/absolute/path/to/server.js"]
    },
    "my-remote-server": {
      "url": "https://api.example.com/mcp"
    }
  }
}
```

### 3. Summary of Steps

- **Identify the Client Configuration File:** Locate the configuration file for your specific AI application (e.g., `~/Library/Application Support/Claude/claude_desktop_config.json` for Claude Desktop, or `.vscode/mcp.json` for VS Code).
    
- **Add the Server:** Add the server details (command/args for local, or URL for remote) to the `mcpServers` object.
    
- **Restart the Client:** In most cases, you must restart the AI application (or refresh the connection) for the new MCP server to be detected and initialized.
    
- **Authenticate (If Necessary):** Some servers will trigger an authentication flow (like an OAuth browser prompt) the first time you try to use their tools.
    

### Do you need to code?

- **If you are just using existing MCP servers:** No, you only need to configure the settings file described above.
    
- **If you are building your own MCP server:** Yes, you would use an MCP SDK (available for Python, TypeScript, Java, etc.) to define the resources, tools, and prompts the server will provide. Even then, you are just writing code to handle tool execution and returning JSON-RPC messages; the protocol standardizes how those messages are sent and received.
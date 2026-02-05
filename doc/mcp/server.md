# Wind MCP Server

Wind UI comes with a built-in [Model Context Protocol (MCP)](https://modelcontextprotocol.io) server that provides up-to-date documentation and code examples directly to your AI coding assistant.

## ❌ Without Wind MCP

LLMs often generate outdated or incorrect Wind UI code:

- ❌ Uses deprecated utility classes from old versions
- ❌ Hallucinated class names that don't exist
- ❌ Generic Tailwind examples that don't work in Flutter

## ✅ With Wind MCP

Wind MCP pulls up-to-date, version-specific documentation straight into your AI assistant's context:

- ✅ Current utility class syntax and examples
- ✅ Flutter-specific code snippets that work
- ✅ Accurate widget documentation

Add `use wind` to your prompt:

```
Create a responsive card layout with Wind UI. use wind
```

```
How do I add hover states to a Wind button? use wind
```

## Installation

**Server URL:** `https://wind-mcp.fluttersdk.com/mcp/wind`

Wind MCP supports both **remote HTTP connections** (recommended) and **local SSE bridge** connections for older clients.

---

### Cursor

Go to: **Settings → Cursor Settings → MCP → Add new global MCP server**

Paste the following into your `~/.cursor/mcp.json` file:

```json
{
  "mcpServers": {
    "wind-ui": {
      "url": "https://wind-mcp.fluttersdk.com/mcp/wind"
    }
  }
}
```

> **Note:** Since Cursor 1.0+, remote HTTP connections are fully supported. For older versions, use the SSE bridge method below.

---

### Claude Code

Run this command to add Wind MCP globally:

```bash
claude mcp add --transport http wind-ui https://wind-mcp.fluttersdk.com/mcp/wind
```

For per-project configuration:

```bash
claude mcp add --scope project wind-ui https://wind-mcp.fluttersdk.com/mcp/wind
```

---

### Claude Desktop

On Windows and macOS, there are official [Claude Desktop applications by Anthropic](https://claude.ai/download).

To configure MCP server settings, go to **File → Settings → Developer → MCP Servers → Edit Config**, which will open `claude_desktop_config.json`.

- **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`

Add the Wind MCP server configuration:

```json
{
  "mcpServers": {
    "wind-ui": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sse", "https://wind-mcp.fluttersdk.com/mcp/wind"]
    }
  }
}
```

> **Important:** Be sure to fully quit Claude Desktop via **File → Exit**, as closing the window just minimizes it.

---

### VS Code (GitHub Copilot)

Create or edit `.vscode/mcp.json` in your project:

```json
{
  "servers": {
    "wind-ui": {
      "type": "http",
      "url": "https://wind-mcp.fluttersdk.com/mcp/wind"
    }
  }
}
```

For user-level configuration, add to your VS Code settings.

---

### Windsurf

Add to your Windsurf MCP configuration:

```json
{
  "mcpServers": {
    "wind-ui": {
      "url": "https://wind-mcp.fluttersdk.com/mcp/wind"
    }
  }
}
```

---

### JetBrains IDEs (Junie / AI Assistant)

**For Junie:** Open Junie, go to the three dots in the top right corner, then **Settings → MCP Settings**:

```json
{
  "mcpServers": {
    "wind-ui": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sse", "https://wind-mcp.fluttersdk.com/mcp/wind"]
    }
  }
}
```

**For AI Assistant:** Go to **Settings → Tools → AI Assistant → MCP** and add via the "as JSON" option.

---

### Cline / Roo-Code

Add to your MCP server configuration (typically `~/.config/cline/mcp.json` or similar):

```json
{
  "mcpServers": {
    "wind-ui": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sse", "https://wind-mcp.fluttersdk.com/mcp/wind"]
    }
  }
}
```

---

### OpenCode

Add to your OpenCode configuration file:

```json
{
  "mcp": {
    "wind-ui": {
      "type": "remote",
      "url": "https://wind-mcp.fluttersdk.com/mcp/wind",
      "enabled": true
    }
  }
}
```

---

### Gemini CLI

Add to your `~/.gemini/settings.json`:

```json
{
  "mcpServers": {
    "wind-ui": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sse", "https://wind-mcp.fluttersdk.com/mcp/wind"]
    }
  }
}
```

---

### Antigravity

[Antigravity](https://antigravity.google/) is Google's AI-powered IDE built on VS Code.

1. Navigate to or open the **Agent** side panel (press `Cmd/Ctrl + L` or go to **View → Open View... → Agent**)
2. In the upper right of the Agent panel, click the **Additional options (...)** menu button
3. Select **MCP Servers**
4. Click **Manage MCP Servers**
5. In the upper right of the Manage MCPs editor view, click **View raw config**
6. Add the following configuration:

```json
{
  "mcpServers": {
    "wind-ui": {
      "serverUrl": "https://wind-mcp.fluttersdk.com/mcp/wind"
    }
  }
}
```

> **Tip:** It's recommended to also install the [Dart and Flutter extensions](https://docs.flutter.dev/tools/vs-code) for the best development experience.

---

### Firebase Studio

[Firebase Studio](https://firebase.studio/) is an agentic cloud-based development environment by Google.

1. In your Firebase Studio project, create a `.idx/mcp.json` file if it doesn't exist
2. Add the following Wind MCP configuration:

```json
{
  "mcpServers": {
    "wind-ui": {
      "url": "https://wind-mcp.fluttersdk.com/mcp/wind"
    }
  }
}
```

1. Rebuild your workspace:
   - Open the Command Palette (`Shift + Ctrl + P`)
   - Enter **Firebase Studio: Rebuild Environment**

---

### Other Clients

For other MCP-compatible clients, use the server URL directly if HTTP transport is supported:

```
https://wind-mcp.fluttersdk.com/mcp/wind
```

If your client only supports stdio transport, use the SSE bridge:

```bash
npx -y @modelcontextprotocol/server-sse https://wind-mcp.fluttersdk.com/mcp/wind
```

---

## Add a Rule

To automatically use Wind MCP for Flutter/Wind questions without typing `use wind`, add a rule to your AI client:

**Cursor:** Settings → Rules

**Claude Code:** Add to `CLAUDE.md`

Example rule:

```
Always use Wind MCP when generating Flutter UI code with Wind utility classes, or when I ask about Wind UI documentation, widgets, or styling.
```

---

## Available Tools

Wind MCP provides the following tool:

### `search_docs`

Searches the Wind UI documentation for specific topics, widgets, or utility classes.

| Parameter | Required | Description |
| :--- | :--- | :--- |
| `query` | Yes | The search term (e.g., "flex", "responsive", "hover states") |
| `version` | No | Documentation version (defaults to latest) |
| `format` | No | Output format: `markdown`, `json`, or `toon` |

**Example prompts:**

```
How do I create a responsive grid using Wind UI?
```

```
What hover state utilities does Wind support?
```

```
Show me how to use WDiv with flexbox utilities.
```

---

## Output Formats

The server supports multiple output formats optimized for different use cases:

| Format | Description |
| :--- | :--- |
| `markdown` | Human-readable format (default) |
| `json` | Structured data for programmatic use |
| `toon` | Token-Optimized Object Notation for efficient LLM context |

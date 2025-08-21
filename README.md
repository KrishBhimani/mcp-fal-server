# fal.ai MCP Server - Docker Deployment

A Model Context Protocol (MCP) server for interacting with fal.ai models and services, optimized for Docker deployment and integration with Agno agents.

## Features

- Generate hyperrealistic images using fal.ai models
- Generate short videos using fal.ai video models
- Support for both direct and queued model execution
- Docker-based deployment for easy hosting
- SSE (Server-Sent Events) transport for remote access
- Automatic environment configuration
- Integration with Agno framework

## Quick Start with Docker

### Prerequisites

- Docker installed on your system
- A fal.ai API key (get one from [fal.ai](https://fal.ai))

### 1. Setup Environment

1. Navigate to the mcp-fal directory:
```bash
cd mcp-fal
```

2. Update the `.env` file with your actual fal.ai API key:
```bash
# Edit .env file
FAL_KEY="your_actual_fal_api_key_here"
HOST=0.0.0.0
PORT=8000
```

### 2. Deploy with Docker

```bash
# Build the Docker image
docker build -t mcp-fal-server .

# Run the container with port mapping
docker run -d -p 8000:8000 --name mcp-fal-server mcp-fal-server
```

### 3. Verify Deployment

Check if the container is running:
```bash
docker ps
```

View container logs:
```bash
docker logs mcp-fal-2
```

## MCP Configuration

Once deployed, use this MCP configuration to connect to your server:

```json
{
  "mcpServers": {
    "fal-ai": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "http://localhost:8000/sse"],
      "env": {}
    }
  }
}
```

For remote deployment, replace `localhost:8000` with your server's domain:

```json
{
  "mcpServers": {
    "fal-ai": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://your-domain.com/sse"],
      "env": {}
    }
  }
}
```

## Configuration

### Environment Variables

The following environment variables are automatically loaded from the `.env` file:

- `FAL_KEY`: Your fal.ai API key (required)
- `HOST`: Server host (default: 0.0.0.0)
- `PORT`: Server port (default: 8000)

### Docker Configuration

The Dockerfile is configured to:
- Use Python 3.11-slim base image
- Automatically copy and load the `.env` file
- Expose port 8000
- Run the server with SSE transport
- Handle environment variables properly

## Troubleshooting

### Common Issues

1. **FAL_KEY not set error**:
   - Ensure your `.env` file contains the correct API key
   - Rebuild the Docker image after updating the `.env` file

2. **Connection refused**:
   - Check if the container is running: `docker ps`
   - Verify port mapping: `-p 8000:8000`

3. **ASGI cleanup errors in logs**:
   - These are harmless connection cleanup errors
   - They don't affect functionality
   - The server continues to work normally

### Useful Commands

```bash
# View real-time logs
docker logs -f mcp-fal-2

# Access container shell
docker exec -it mcp-fal-2 /bin/bash

# Check environment variables in container
docker exec mcp-fal-2 env | grep FAL

# Restart container
docker restart mcp-fal-2
```

## Architecture

```
┌─────────────────┐    HTTP/SSE    ┌──────────────────┐    API Calls    ┌─────────────┐
│   MCP Client    │ ──────────────► │  MCP Server      │ ──────────────► │   fal.ai    │
│  (Agno Agent)   │                │  (Docker)        │                 │   Service   │
└─────────────────┘                └──────────────────┘                 └─────────────┘
```

## Development

### Building Custom Images

To build with a different tag:
```bash
docker build -t my-fal-mcp .
docker run -d -p 8000:8000 --name my-fal-container my-fal-mcp
```

## License

MIT License - See LICENSE file for details.

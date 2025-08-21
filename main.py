"""
fal.ai MCP Server : Main entry point

This module sets up and runs the fal.ai MCP server,
providing tools to interact with fal.ai models and services.
Supports both stdio and SSE (Server-Sent Events) transports.
"""

import os
import sys
import argparse
from dotenv import load_dotenv
from fastmcp import FastMCP
from api.models import register_model_tools
from api.generate import register_generation_tools
from api.storage import register_storage_tools
from api.config import get_api_key, SERVER_NAME, SERVER_DESCRIPTION, SERVER_VERSION, SERVER_DEPENDENCIES

# Load environment variables from .env file
load_dotenv()

mcp = FastMCP(SERVER_NAME)

register_model_tools(mcp)
register_generation_tools(mcp)
register_storage_tools(mcp)

def main():
    parser = argparse.ArgumentParser(description="fal.ai MCP Server")
    parser.add_argument("--transport", choices=["stdio", "sse"], default="stdio",
                       help="Transport method (stdio for local, sse for remote hosting)")
    parser.add_argument("--host", default="0.0.0.0", help="Host to bind to (for SSE transport)")
    parser.add_argument("--port", type=int, default=8000, help="Port to bind to (for SSE transport)")
    
    args = parser.parse_args()
    
    try:
        get_api_key()
    except ValueError:
        print("Warning: FAL_KEY environment variable not set", file=sys.stderr)
        pass
    
    try:
        if args.transport == "sse":
            print(f"Starting fal.ai MCP Server on {args.host}:{args.port} with SSE transport")
            mcp.run(transport="sse")
        else:
            print("Starting fal.ai MCP Server with stdio transport")
            mcp.run()
    except KeyboardInterrupt:
        print("Server stopped by user", file=sys.stderr)
        sys.exit(0)
    except Exception as e:
        print(f"Error starting server: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()

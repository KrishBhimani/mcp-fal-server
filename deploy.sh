#!/bin/bash

# fal.ai MCP Server Deployment Script

set -e

echo "🚀 fal.ai MCP Server Deployment Script"
echo "======================================"

# Check if FAL_KEY is set
if [ -z "$FAL_KEY" ]; then
    echo "❌ Error: FAL_KEY environment variable is not set"
    echo "Please set your fal.ai API key:"
    echo "export FAL_KEY='your_fal_api_key_here'"
    exit 1
fi

# Function to display usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --local         Run server locally with SSE transport"
    echo "  --docker        Build and run with Docker"
    echo "  --compose       Run with docker-compose"
    echo "  --build-only    Only build Docker image"
    echo "  --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --local                    # Run locally on port 8000"
    echo "  $0 --docker                   # Build and run with Docker"
    echo "  $0 --compose                  # Run with docker-compose"
}

# Parse command line arguments
case "${1:-}" in
    --local)
        echo "🟡 Starting fal.ai MCP Server locally..."
        echo "Server will be available at: http://localhost:8000"
        echo "SSE endpoint: http://localhost:8000/sse"
        echo ""
        python main.py --transport sse --host 0.0.0.0 --port 8000
        ;;
    
    --docker)
        echo "🟡 Building Docker image..."
        docker build -t mcp-fal-server .
        echo "✅ Docker image built successfully"
        
        echo "🟡 Starting container..."
        docker run -d \
            --name mcp-fal-server \
            -p 8000:8000 \
            -e FAL_KEY="$FAL_KEY" \
            --restart unless-stopped \
            mcp-fal-server
        
        echo "✅ Container started successfully"
        echo "Server is available at: http://localhost:8000"
        echo "SSE endpoint: http://localhost:8000/sse"
        echo ""
        echo "To view logs: docker logs mcp-fal-server"
        echo "To stop: docker stop mcp-fal-server"
        ;;
    
    --compose)
        echo "🟡 Creating .env file..."
        echo "FAL_KEY=$FAL_KEY" > .env
        echo "✅ .env file created"
        
        echo "🟡 Starting with docker-compose..."
        docker-compose up -d
        echo "✅ Services started successfully"
        echo "Server is available at: http://localhost:8000"
        echo "SSE endpoint: http://localhost:8000/sse"
        echo ""
        echo "To view logs: docker-compose logs -f"
        echo "To stop: docker-compose down"
        ;;
    
    --build-only)
        echo "🟡 Building Docker image only..."
        docker build -t mcp-fal-server .
        echo "✅ Docker image built successfully"
        ;;
    
    --help)
        usage
        ;;
    
    "")
        echo "❌ No option specified"
        echo ""
        usage
        exit 1
        ;;
    
    *)
        echo "❌ Unknown option: $1"
        echo ""
        usage
        exit 1
        ;;
esac

FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Copy environment file if it exists, otherwise use example
COPY .env* ./
RUN if [ ! -f .env ]; then cp .env.example .env; fi

# Expose the port
EXPOSE 8000

# Set environment variables
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

# Set default environment variables from .env file
ENV HOST=0.0.0.0
ENV PORT=8000

# Health check
# HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
#     CMD curl -f http://localhost:8000/health || exit 1

# Run the server with SSE transport
CMD ["python", "main.py", "--transport", "sse", "--host", "0.0.0.0", "--port", "8000"]

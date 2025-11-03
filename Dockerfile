FROM node:20-alpine

# Install n8n globally
RUN npm install -g n8n@latest

# Create app directory
WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 n8n && \
    adduser -u 1001 -G n8n -s /bin/sh -D n8n

# Change ownership
RUN chown -R n8n:n8n /app

# Switch to non-root user
USER n8n

# Expose default n8n port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

# Start n8n binding to all interfaces (0.0.0.0)
CMD ["n8n", "start", "--host", "0.0.0.0"]

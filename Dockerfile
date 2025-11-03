# Use latest Node Alpine image
FROM node:20-alpine

# Install n8n globally
RUN npm install -g n8n@latest

# Create app directory
WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 n8n && \
    adduser -u 1001 -G n8n -s /bin/sh -D n8n

# Change ownership of app directory
RUN chown -R n8n:n8n /app

# Switch to non-root user
USER n8n

# Expose port (Railway will map dynamic $PORT)
EXPOSE 5678

# Health check (optional)
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:$PORT/healthz || exit 1

# Start n8n binding to all interfaces and using Railway dynamic port
CMD ["sh", "-c", "n8n start --host 0.0.0.0 --port $PORT"]

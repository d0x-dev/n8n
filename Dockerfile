FROM node:20-alpine

# Install n8n globally
RUN npm install -g n8n@latest

# Create app directory
WORKDIR /app

# Create non-root user
RUN addgroup -g 1000 n8n && \
    adduser -u 1000 -G n8n -s /bin/sh -D n8n

# Switch to non-root user
USER n8n

# Expose port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

# Start n8n with tunnel
CMD ["n8n", "start", "--tunnel"]

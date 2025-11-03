FROM node:20-alpine

# Install n8n globally
RUN npm install -g n8n@latest

# App directory
WORKDIR /app

# Non-root user
RUN addgroup -g 1001 n8n && \
    adduser -u 1001 -G n8n -s /bin/sh -D n8n

RUN chown -R n8n:n8n /app
USER n8n

EXPOSE 5678

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

# Start n8n bound to all interfaces
CMD ["n8n", "start", "--host", "0.0.0.0"]

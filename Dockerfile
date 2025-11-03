# Use supported Node.js version for n8n (>=20.19)

FROM node:24-alpine

# Install n8n globally

RUN npm install -g n8n@latest

# Set working directory

WORKDIR /app

# Create non-root user

RUN addgroup -g 1001 n8n && 
adduser -u 1001 -G n8n -s /bin/sh -D n8n

# Ensure n8n owns the app directory

RUN chown -R n8n:n8n /app

# Switch to non-root user

USER n8n

# Expose internal n8n port (Railway maps external dynamically)

EXPOSE 5678

# Optional health check for Railway

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 
CMD curl -f [http://localhost:$PORT/healthz](http://localhost:$PORT/healthz) || exit 1

# Set environment variables for production defaults

ENV NODE_ENV=production 
N8N_PROTOCOL=https 
EXECUTIONS_PROCESS=main 
# Optional defaults, override in Railway UI
N8N_HOST=n8n.stormx.pw 
WEBHOOK_URL=[https://n8n.stormx.pw/](https://n8n.stormx.pw/)

# Start n8n on all interfaces using Railway dynamic port

CMD ["sh", "-c", "n8n start --host 0.0.0.0 --port $PORT"]

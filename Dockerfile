# Use supported Node.js version for n8n (>=20.19)
FROM node:24-alpine

# Install curl (optional, used in workflows)
RUN apk add --no-cache curl

# Install n8n globally
RUN npm install -g n8n@latest

# Set working directory
WORKDIR /app

# Create non-root user and set ownership
RUN addgroup -S n8n && adduser -S -G n8n n8n && chown -R n8n:n8n /app

# Switch to non-root user
USER n8n

# Expose internal n8n port (Railway maps external dynamically)
EXPOSE 5678

# Set environment variables for production
ENV NODE_ENV=production
ENV N8N_HOST=n8n.stormx.pw
ENV N8N_PROTOCOL=https
ENV WEBHOOK_URL=https://n8n.stormx.pw/
ENV N8N_RUNNERS_ENABLED=true
ENV N8N_BLOCK_ENV_ACCESS_IN_NODE=false
ENV N8N_GIT_NODE_DISABLE_BARE_REPOS=true
ENV DB_SQLITE_POOL_SIZE=5

# Optional: persistent storage path
# Mount a volume at /home/n8n/.n8n in Railway to preserve workflows, credentials, etc.

# Start n8n on all interfaces using Railway dynamic port
CMD ["sh", "-c", "n8n start --host 0.0.0.0 --port $PORT"]

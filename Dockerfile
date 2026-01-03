# Multi-stage build for Memos on Render
# Stage 1: Build Frontend
FROM node:20-alpine AS frontend
WORKDIR /frontend-build

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy package files
COPY web/package.json web/pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy frontend source
COPY web/ ./

# Build frontend
RUN pnpm build

# Stage 2: Build Backend
FROM golang:1.25-alpine AS backend
WORKDIR /backend-build

# Install build dependencies
RUN apk add --no-cache git

# Copy go modules
COPY go.mod go.sum ./
RUN go mod download

# Copy backend source
COPY . .

# Copy built frontend from previous stage
COPY --from=frontend /frontend-build/dist ./server/router/frontend/dist

# Build backend
RUN go build -ldflags="-s -w" -o memos ./cmd/memos

# Stage 3: Final Runtime Image
FROM alpine:latest
WORKDIR /usr/local/memos

# Install runtime dependencies
RUN apk add --no-cache tzdata ca-certificates

# Set timezone
ENV TZ="UTC"

# Copy binary from backend build
COPY --from=backend /backend-build/memos /usr/local/memos/

# Create data directory
RUN mkdir -p /var/opt/memos
VOLUME /var/opt/memos

# Set environment variables
ENV MEMOS_MODE="prod"
ENV MEMOS_PORT="5230"

# Expose port
EXPOSE 5230

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:5230/healthz || exit 1

# Run the application
ENTRYPOINT ["./memos"]

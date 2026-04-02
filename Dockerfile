# ─────────────────────────────────────────────
# Stage 1 — Build Flutter Web
# ─────────────────────────────────────────────
FROM ghcr.io/cirruslabs/flutter:3.29.3 AS builder

WORKDIR /app

# Copy dependency manifests first (layer-caching)
COPY pubspec.yaml pubspec.lock ./

# Download pub packages
RUN flutter pub get

# Copy the rest of the source
COPY . .

# Build a release web bundle
RUN flutter build web --release --no-tree-shake-icons

# ─────────────────────────────────────────────
# Stage 2 — Serve with Nginx
# ─────────────────────────────────────────────
FROM nginx:1.27-alpine AS runner

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy built web app
COPY --from=builder /app/build/web /usr/share/nginx/html

# Nginx config: serve index.html for all routes (SPA / Flutter Web)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]


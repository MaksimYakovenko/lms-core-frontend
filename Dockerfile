# ── Stage 1: build Flutter web ─────────────────────────────────────────────
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

RUN flutter build web --release

# ── Stage 2: serve with python3 (respects Railway PORT env var) ────────────
FROM python:3.12-slim AS server

WORKDIR /srv

COPY --from=builder /app/build/web ./web

EXPOSE 8080

CMD ["sh", "-c", "cd web && python3 -m http.server ${PORT:-8080}"]

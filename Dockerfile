# Planka with Lyra Trello-Vibe theme baked in
# Wraps the official Planka 2.x image and injects our custom stylesheet.
# Built for tasks.vibeagency.net (Railway deployment).

FROM ghcr.io/plankanban/planka:latest

# Switch to root for filesystem mods (Planka image runs as non-root by default)
USER root

# Find Planka's public folder dynamically (may be /app/public, /app/client/dist, etc).
# RUN as one command so the variable is available across.
RUN set -eux; \
  PUBLIC_DIR=$(find /app -maxdepth 4 -name index.html -not -path '*/node_modules/*' -printf '%h\n' | head -1); \
  echo "Public dir: $PUBLIC_DIR"; \
  ls -la "$PUBLIC_DIR" || true

# Copy our custom stylesheet into the public folder via shell that resolves the path
COPY lyra-custom.css /tmp/lyra-custom.css
RUN set -eux; \
  PUBLIC_DIR=$(find /app -maxdepth 4 -name index.html -not -path '*/node_modules/*' -printf '%h\n' | head -1); \
  cp /tmp/lyra-custom.css "$PUBLIC_DIR/lyra-custom.css"; \
  sed -i 's|</head>|<link rel="stylesheet" href="/lyra-custom.css"></head>|I' "$PUBLIC_DIR/index.html"; \
  grep -c lyra-custom.css "$PUBLIC_DIR/index.html"

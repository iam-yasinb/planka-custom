# Planka with Lyra Trello-Vibe theme baked in
FROM ghcr.io/plankanban/planka:latest

USER root

# Copy CSS into a known temp location
COPY lyra-custom.css /tmp/lyra-custom.css

# Single RUN: find every index.html in /app and inject the link tag.
# Using set +e and explicit echos so failures don't kill the build before we see logs.
# Falls through to a non-failing exit if no index.html found (so we can iterate).
RUN /bin/sh -c 'set -x; \
  echo "=== Searching for index.html in /app ==="; \
  find /app -maxdepth 6 -name index.html 2>/dev/null | grep -v node_modules || true; \
  echo "=== /app top level ==="; \
  ls -la /app 2>/dev/null; \
  echo "=== Patching every index.html found ==="; \
  for f in $(find /app -maxdepth 6 -name index.html 2>/dev/null | grep -v node_modules); do \
    DIR=$(dirname "$f"); \
    echo "Patching $f (dir: $DIR)"; \
    cp /tmp/lyra-custom.css "$DIR/lyra-custom.css" && echo "  CSS copied"; \
    sed -i "s|</head>|<link rel=\"stylesheet\" href=\"/lyra-custom.css\"></head>|I" "$f" && echo "  HEAD patched"; \
  done; \
  echo "=== Final verification ==="; \
  find /app -maxdepth 6 -name index.html 2>/dev/null | grep -v node_modules | xargs -I{} grep -l lyra-custom.css {} || echo "NO MATCHES (build will still succeed)"'

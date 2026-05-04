# Planka with Lyra Trello-Vibe theme baked in
FROM ghcr.io/plankanban/planka:latest

USER root

COPY lyra-custom.css /tmp/lyra-custom.css

# Find Planka's index.html (excluding node_modules vendor demos), inject CSS link.
# Build fails if zero patches happen.
RUN /bin/sh -ec 'echo "=== Looking for Planka index.html ==="; \
  TARGETS=$(find /app -name index.html -not -path "*/node_modules/*" 2>/dev/null | xargs -I{} sh -c "grep -l \"PLANKA\" {} 2>/dev/null" | xargs -I{} sh -c "grep -l \"</head>\" {} 2>/dev/null"); \
  echo "Targets: $TARGETS"; \
  COUNT=0; \
  for f in $TARGETS; do \
    DIR=$(dirname "$f"); \
    cp /tmp/lyra-custom.css "$DIR/lyra-custom.css"; \
    sed -i "s|</head>|<link rel=\"stylesheet\" href=\"/lyra-custom.css\"></head>|I" "$f"; \
    if grep -q lyra-custom.css "$f"; then echo "PATCHED: $f (CSS at $DIR/lyra-custom.css)"; COUNT=$((COUNT+1)); fi; \
  done; \
  echo "Total patched: $COUNT"; \
  if [ "$COUNT" -eq 0 ]; then \
    echo "FAIL: No Planka index.html found. Listing all candidates:"; \
    find /app -name index.html -not -path "*/node_modules/*" 2>/dev/null; \
    echo "--- All HTML files in /app (top 50) ---"; \
    find /app -name "*.html" -not -path "*/node_modules/*" 2>/dev/null | head -50; \
    echo "--- Looking for PLANKA string anywhere ---"; \
    grep -rl PLANKA /app 2>/dev/null | head -20; \
    exit 1; \
  fi'

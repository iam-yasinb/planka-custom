# Planka with Lyra Trello-Vibe theme baked in
FROM ghcr.io/plankanban/planka:latest

USER root

COPY lyra-custom.css /tmp/lyra-custom.css

# Search whole filesystem for index.html with </head>, copy CSS to its dir, sed-inject link.
# Build fails if zero files patched (so we don't ship a no-op image).
RUN /bin/sh -ec 'echo "=== ALL index.html files ==="; \
  find / -name index.html -not -path "/proc/*" -not -path "/sys/*" 2>/dev/null; \
  echo "=== Files containing </head> ==="; \
  TARGETS=$(find / -name index.html -not -path "/proc/*" -not -path "/sys/*" 2>/dev/null | xargs -I{} sh -c "grep -l \"</head>\" {} 2>/dev/null"); \
  echo "$TARGETS"; \
  COUNT=0; \
  for f in $TARGETS; do \
    DIR=$(dirname "$f"); \
    cp /tmp/lyra-custom.css "$DIR/lyra-custom.css"; \
    sed -i "s|</head>|<link rel=\"stylesheet\" href=\"/lyra-custom.css\"></head>|I" "$f"; \
    if grep -q lyra-custom.css "$f"; then echo "PATCHED: $f"; COUNT=$((COUNT+1)); fi; \
  done; \
  echo "Total patched: $COUNT"; \
  if [ "$COUNT" -eq 0 ]; then echo "FAIL: no index.html patched"; exit 1; fi'

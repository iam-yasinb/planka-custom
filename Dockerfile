# Planka with Lyra Trello-Vibe theme baked in
# Planka serves /app/public statically AND renders /app/views/index.ejs server-side.
# We patch BOTH: copy CSS into /app/public/lyra-custom.css, inject link tag into index.ejs.
FROM ghcr.io/plankanban/planka:latest

USER root

COPY lyra-custom.css /app/public/lyra-custom.css

RUN /bin/sh -ec 'echo "=== Patching /app/views/index.ejs ==="; \
  if [ ! -f /app/views/index.ejs ]; then echo "FAIL: /app/views/index.ejs not found"; ls -la /app/views/ 2>/dev/null || echo "no /app/views"; find /app -name "*.ejs" 2>/dev/null | head; exit 1; fi; \
  cat /app/views/index.ejs | head -20; \
  echo "---"; \
  sed -i "s|</head>|<link rel=\"stylesheet\" href=\"/lyra-custom.css\"></head>|I" /app/views/index.ejs; \
  if grep -q lyra-custom.css /app/views/index.ejs; then echo "PATCHED OK"; else echo "FAIL: patch did not stick"; cat /app/views/index.ejs; exit 1; fi; \
  ls -la /app/public/lyra-custom.css'

USER node

# Planka with Lyra Trello-Vibe theme baked in
# Wraps the official Planka 2.x image and injects our custom stylesheet.
# Built for tasks.vibeagency.net (Railway deployment).
#
# IMPORTANT: use ghcr.io/plankanban/planka:latest (not docker.io/plankanban/planka)
# Planka publishes only to GHCR; Docker Hub returns 'insufficient_scope'.

FROM ghcr.io/plankanban/planka:latest

# Copy our custom stylesheet into the served public folder
COPY lyra-custom.css /app/public/lyra-custom.css

# Inject the stylesheet link into index.html.
# Planka's index.html is served as-is from /app/public — modifying it once at
# build time means every page load gets our theme without runtime overhead.
RUN sed -i 's|</head>|<link rel="stylesheet" href="/lyra-custom.css"></head>|' /app/public/index.html

# All other config inherited from upstream image. CMD/ENTRYPOINT unchanged.

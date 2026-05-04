# Planka with Lyra Trello-Vibe theme baked in
# Wraps the official Planka 2.x image and injects our custom stylesheet.
# Built for tasks.vibeagency.net (Railway deployment).

FROM plankanban/planka:latest

# Copy our custom stylesheet into the served public folder
COPY lyra-custom.css /app/public/lyra-custom.css

# Inject the stylesheet link into index.html.
# Planka's index.html is served as-is from /app/public — modifying it once at
# build time means every page load gets our theme without any runtime overhead.
# We use sed to inject the <link> tag right before </head>.
RUN sed -i 's|</head>|<link rel="stylesheet" href="/lyra-custom.css"></head>|' /app/public/index.html

# All other config (PORT, DATABASE_URL, BASE_URL, SECRET_KEY, etc.) is
# inherited from the existing Railway service environment variables.
# We do NOT override CMD/ENTRYPOINT — the upstream image's startup is correct.

FROM pandoc/latex:3.10-debian

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    npm \
    chromium \
    ca-certificates \
    fonts-freefont-ttf \
    libnss3 \
    libfreetype6 \
    libharfbuzz0b \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @mermaid-js/mermaid-cli mermaid-filter

# Puppeteer config for running Chromium as root (no sandbox)
# Placed in /etc so volume mounts over /data don't hide it
RUN printf '%s\n' \
    '{' \
    '  "args": ["--no-sandbox", "--disable-setuid-sandbox"]' \
    '}' > /etc/puppeteer-config.json

# Wrap the real mmdc to always pass --no-sandbox puppeteer config,
# then symlink it so mermaid-filter's bundled path resolves correctly
RUN mv /usr/local/bin/mmdc /usr/local/bin/mmdc-real \
    && printf '%s\n' \
    '#!/bin/sh' \
    'exec /usr/local/bin/mmdc-real -p /etc/puppeteer-config.json "$@"' \
    > /usr/local/bin/mmdc \
    && chmod +x /usr/local/bin/mmdc \
    && rm -rf /usr/local/lib/node_modules/mermaid-filter/node_modules/.bin/mmdc \
    && ln -s /usr/local/bin/mmdc /usr/local/lib/node_modules/mermaid-filter/node_modules/.bin/mmdc

WORKDIR /data

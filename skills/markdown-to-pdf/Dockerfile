FROM pandoc/latex:3.10-debian

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium
ENV NODE_PATH=/usr/local/lib/node_modules

RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    npm \
    chromium \
    ca-certificates \
    fonts-freefont-ttf \
    libnss3 \
    libfreetype6 \
    libharfbuzz0b \
    fonts-noto-color-emoji \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @mermaid-js/mermaid-cli mermaid-filter playwright

# Puppeteer config for running Chromium as root (no sandbox)
# Placed in /etc so volume mounts over /data don't hide it
RUN printf '%s\n' \
    '{' \
    '  "args": ["--no-sandbox", "--disable-setuid-sandbox", "--disable-crash-reporter", "--disable-crashpad"]' \
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

COPY scripts/render-mermaid.py /usr/local/bin/render-mermaid.py
COPY scripts/render-pdf.mjs /usr/local/bin/render-pdf.mjs
COPY templates/print.css /opt/markdown-to-pdf/print.css
COPY templates/report.html /opt/markdown-to-pdf/report.html

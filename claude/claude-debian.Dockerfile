# syntax=docker/dockerfile:1

FROM debian:trixie-slim

LABEL org.opencontainers.image.description="Debian Trixie Slim with Claude Code CLI"

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        # Download libraries for cURL setup scripts \
        ca-certificates \
        curl \
        gnupg \
        unzip \
        # Download runtime libraries \
        bash \
        git \
        sudo \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends \
        nodejs \
    \
    && curl -fsSL https://astral.sh/uv/install.sh | UV_UNMANAGED_INSTALL=/usr/local/bin bash \
    && uv python install --default 3.11 \
    && uv venv --directory /root \
    && echo 'alias pip="uv pip"' >> /etc/bash.bashrc \
    \
    && npm install --global @anthropic-ai/claude-code@2.1.152 \
    \
    && npm cache clean --force >/dev/null 2>&1 || true \
    && echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/nopasswd \
    && apt-get autoremove -y -qq \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /var/cache/apt/archives/* \
        /var/log/* \
        /tmp/* \
        /root/.npm \
        /root/.cache \
        /usr/include \
        /usr/share/doc \
        /usr/share/man \
        /usr/share/info \
        /usr/share/groff \
        /usr/share/lintian \
        /usr/share/linda \
        /usr/share/help \
        /usr/share/X11

COPY --chmod=+x _entrypoints/localhost-to-machine-entrypoint.sh /entrypoint.sh

ENV PATH="/root/.local/bin:${PATH}"
ENV ENTRYPOINT_EXEC="claude"

WORKDIR /workspace
ENTRYPOINT ["/bin/bash", "-c", ". /root/.venv/bin/activate && exec /entrypoint.sh \"$@\""]

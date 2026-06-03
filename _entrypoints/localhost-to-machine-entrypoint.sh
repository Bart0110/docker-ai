#!/usr/bin/env bash
set -euo pipefail

HOST_INTERNAL="${DOCKER_HOST_INTERNAL:-host.docker.internal}"

# Resolve HOST_INTERNAL to an IP, defaulting to 127.0.0.1 if resolution fails
HOST_IP=$(getent hosts "$HOST_INTERNAL" 2>/dev/null | awk '{print $1}' | head -n1)
HOST_IP="${HOST_IP:-127.0.0.1}"

# Make localhost resolve to the resolved HOST_INTERNAL IP
echo "$HOST_IP localhost host.docker.internal" > /etc/hosts

cd /workspace
exec "$ENTRYPOINT_EXEC" "$@"

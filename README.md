<p align="center">
  <strong>Docker images to contain coder agents into a safe(er) environment.</strong>
</p>

## Containers

There are multiple containers available with their own bash bootstrapping functions.
You need to add the functions to your bashrc (or equivalent shell) to persist history and settings.

### Claude

**Image:** `ghcr.io/bart0110/docker-ai:claude-debian-main`

#### Bootstrapping

```bash

```

### Oh My Pi

**Image:** `ghcr.io/bart0110/docker-ai:omp-debian-main`

#### Bootstrapping

```bash
omp-sandbox() {
  local SESS
  # 1. Replace all / with -
  # 2. Force the start to be '--' (replacing the leading dash)
  #    and append '--' to the very end
  SESS=$(printf '%s' "$PWD" | tr '/' '-' | sed 's/^-/--/; s/$/--/')

  mkdir -p "$HOME/.omp/agent"
  chmod 700 "$HOME/.omp/agent"

  [ -f "$HOME/.omp/agent/config.yml" ] || touch "$HOME/.omp/agent/config.yml"
  [ -f "$HOME/.omp/agent/models.yml" ] || touch "$HOME/.omp/agent/models.yml"

  mkdir -p "$HOME/.omp/agent/sessions/$SESS"

  docker run --rm -it \
    -e "DOCKER_HOST_INTERNAL=$DOCKER_HOST_INTERNAL" \
    -v "$HOME/.omp/agent/config.yml:/root/.omp/agent/config.yml" \
    -v "$HOME/.omp/agent/models.yml:/root/.omp/agent/models.yml:ro" \
    -v "$HOME/.omp/agent/sessions/$SESS:/root/.omp/agent/sessions/--workspace--" \
    -v "$PWD:/workspace" \
    TODO \
    "$@"
}
```

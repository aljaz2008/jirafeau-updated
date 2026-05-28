# Jirafeau (Modernized Deployment)

Production-focused containerized deployment for secure, high-throughput large-file transfer.

## Features
- Non-root, minimal container runtime.
- Nginx + PHP-FPM tuned for multi-GB uploads and high concurrency.
- Automated expiration cleanup (`clean_expired`, `clean_async`) via dedicated worker.
- GHCR-ready CI/CD with buildx, SBOM, Trivy, and CodeQL.

## Quick Start
1. Copy env file: `cp .env.example .env`
2. Set your own image name/tag in `docker-compose.yml`.
3. Provide secure runtime config in `lib/config.local.php`.
4. Deploy: `docker compose pull && docker compose up -d`

## Docker Compose Deployment

### Example `.env`
```env
HTTP_PORT=8080
TZ=UTC
CLEANUP_INTERVAL_SECONDS=300
```

### Pull and Start
```bash
docker compose pull
docker compose up -d
```

### Safe Update Procedure
```bash
docker compose pull
docker compose up -d --remove-orphans
docker image prune -f
```

### Persistent Storage
- `jirafeau-data` stores uploaded files, links metadata, and async artifacts.
- Back up the named volume and your `lib/config.local.php`.

### Cleanup & Expiration Enforcement
- `cleanup` service runs every `CLEANUP_INTERVAL_SECONDS`.
- It executes `php admin.php clean_expired` and `php admin.php clean_async`.
- Expired files become inaccessible and are removed from storage automatically.

### Reverse Proxy & HTTPS
- Put `web` behind Traefik/Nginx Proxy Manager/HAProxy/Cloudflare.
- Terminate TLS at the edge.
- Increase proxy timeouts and max upload body size to match 10G defaults.
- Preserve real client IP with trusted proxy chain.

## Performance Tuning
- Nginx: `worker_processes auto`, `worker_connections 4096`, disabled FastCGI request buffering.
- PHP-FPM: dynamic process manager with bounded workers and unlimited upload execution time.
- Keep storage on SSD-backed volumes.

## Hardening Recommendations
- Keep container root filesystems read-only.
- Drop all capabilities and keep `no-new-privileges`.
- Keep secrets out of images (`lib/config.local.php` via mounted secret/volume).
- Patch base images regularly.

## Troubleshooting
- Check health: `docker compose ps`
- Web logs: `docker compose logs -f web`
- App logs: `docker compose logs -f app`
- Cleanup logs: `docker compose logs -f cleanup`

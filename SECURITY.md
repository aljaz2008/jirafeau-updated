# Security Policy

## Reporting a Vulnerability
Please open a private security advisory or contact maintainers directly. Include impact, reproduction steps, and logs.

## Hardening Baseline
- Run behind TLS reverse proxy only.
- Keep `lib/config.local.php` outside images and inject by volume/secret.
- Use non-root containers, `no-new-privileges`, dropped capabilities, read-only root filesystems.
- Restrict trusted proxy headers at edge (Cloudflare/Traefik/Nginx).
- Enforce regular patching of base images and dependencies.

## Operational Security
- Rotate admin/upload passwords and tokens.
- Back up only metadata + encrypted blobs; test restore.
- Run cleanup worker continuously so expired and async artifacts are removed.

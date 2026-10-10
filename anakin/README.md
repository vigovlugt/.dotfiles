# Anakin

## Secrets

Secrets are encrypted with [agenix](https://github.com/ryantm/agenix) in `secrets/` and decrypted to `/run/agenix/` on activation, using anakin's SSH host key. `secrets/agenix-rules.nix` lists who can decrypt each file (cassian's SSH key and anakin's host key).

```bash
cd anakin/secrets
agenix -e gatus.env.age # edit (or create: also add it to agenix-rules.nix)
agenix -r              # re-encrypt all after changing keys in agenix-rules.nix
```

Services do not restart on a secret change; restart them manually after deploying.

After reinstalling anakin, its SSH host key changes: update `anakin` in `secrets/agenix-rules.nix` (`ssh-keyscan -t ed25519 anakin`) and run `agenix -r` from cassian before deploying.

## Setup

### CouchDB

1. export hostname=anakin:5984 export username=admin export password=admin && curl -s https://raw.githubusercontent.com/vrtmrz/obsidian-livesync/main/utils/couchdb/couchdb-init.sh | bash

### Syncthing

GUI password and node identity (`cert.pem`, `key.pem`) are in `secrets/syncthing-*.age`. To generate a new node identity:

```bash
syncthing generate --home /tmp/syncthing
# then encrypt /tmp/syncthing/{cert,key}.pem into secrets/syncthing-{cert,key}.pem.age
```

### Caddy

`secrets/caddy.env.age`:

```bash
CLOUDFLARE_API_TOKEN=""
```

### Gatus

`secrets/gatus.env.age`, with a Gmail app password from https://myaccount.google.com/apppasswords (requires 2-step verification):

```bash
GMAIL_APP_PASSWORD=""
```

### Backup

`secrets/restic.env.age`:

```bash
# anakin-backup
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
RESTIC_PASSWORD=""
RESTIC_REPOSITORY=""
HEALTHCHECKSIO_UUID=""
```

#### Setup new repository

1. Run `sudo -s`, then `set -o allexport && source /run/agenix/restic-env && set +o allexport`
2. Run `sudo -E restic init`

```
systemctl stop couchdb opencloud
restic backup /var/lib/opencloud /var/lib/couchdb
systemctl start couchdb opencloud
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
```

## Backup

### Setup

See [this](#backup)

### Backup

`sudo systemctl start restic-backup`
`journalctl -u restic-backup -f`

### Restore

1. `sudo -s`, then `set -o allexport && source /run/agenix/restic-env && set +o allexport`
2. `sudo -E restic restore latest --target /`

Restore one folder
`sudo -E restic restore latest --target / --include /var/lib/opencloud`

See snapshots
`sudo -E restic snapshots`

### Prune

`sudo -E restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune`

### TODO

Create pulumi for cloudflare healthchecksio tailscale

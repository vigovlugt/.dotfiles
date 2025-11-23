# Anakin

## Setup

### CouchDB

1. export hostname=anakin:5984 export username=admin export password=admin && curl -s https://raw.githubusercontent.com/vrtmrz/obsidian-livesync/main/utils/couchdb/couchdb-init.sh | bash

### Caddy

1. Create /etc/caddy/secrets.env

```bash
CLOUDFLARE_API_TOKEN=""
```

### Backup

1. Create /etc/restic/secrets.env

```bash
# anakin-backup
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
RESTIC_PASSWORD=""
RESTIC_REPOSITORY=""
HEALTHCHECKSIO_UUID=""
```

#### Setup new repository

After creating /etc/restic/secrets.env

1. Run `set -o allexport && source /etc/restic/secrets.env && set +o allexport`
2. Run `sudo -E restic init`

```
systemctl stop couchdb opencloud
restic backup /var/lib/opencloud /var/lib/couchdb
systemctl start couchdb opencloud
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
```

### Tandoor

1. Create /etc/tandoor-recipes/secrets.env

```bash
SECRET_KEY=""
```

## Backup

### Setup

See [this](#backup)

### Backup

`sudo systemctl start restic-backup`
`journalctl -u restic-backup -f`

### Restore

After creating /etc/restic/secrets.env

1. `set -o allexport && source /etc/restic/secrets.env && set +o allexport`
2. `sudo -E restic restore latest --target /`

Restore one folder
`sudo -E restic restore latest --target / --include /var/lib/opencloud`

See snapshots
`sudo -E restic snapshots`

### Prune

`sudo -E restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune`

### TODO

Create pulumi for cloudflare healthchecksio tailscale

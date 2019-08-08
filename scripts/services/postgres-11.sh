#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source ./scripts/slugify.sh

# Create Script Vars
creator=$(slugify "$1")
# dbname="$(pwgen --no-vowels --ambiguous --no-capitalize 10)"
suffix="$(pwgen --no-vowels --ambiguous --no-capitalize 4)"
username="$(pwgen --no-vowels --ambiguous --no-capitalize 10)"
password="$(pwgen --no-vowels 32)"
port=$(node ./scripts/get-available-port.js)
hostname=${PUBLIC_IP:-}

if [[ -z "$hostname" ]]; then
    echo "This script requires an environment variable configured: PUBLIC_IP"
    exit 1
fi

# POSTGRES_USER="$username"
POSTGRES_USER="$creator-$port-$suffix"
POSTGRES_PASSWORD="$password"
POSTGRES_DB="postgres"

printf '\n\n\nCONNECTION STRING: %s\n\n\n' "postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@$PUBLIC_IP:$port/$POSTGRES_DB"

docker run \
  --shm-size=256MB \
  -e POSTGRES_USER="$POSTGRES_USER" \
  -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
  -e POSTGRES_DB="$POSTGRES_DB" \
  -e LANG="en_US.utf8" \
  -p "$port:$port" \
  --name "$creator-$port-$suffix" \
  -d \
  postgres:11 \
  postgres -p "$port" -c "shared_buffers=256MB" -c "max_connections=25" -c "work_mem=8MB" -c "listen_addresses=*"

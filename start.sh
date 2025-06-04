#!/bin/sh

# exit immediately if a command exits with a non-zero status
set -e

echo "run db migration"
/app/migrate -path /app/migration -database "$DB_SOURCE" up

echo "start the app"
exec "$@"
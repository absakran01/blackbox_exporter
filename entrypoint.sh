#!/bin/bash
# Script to substitute environment variables in template files

set -e

echo "Generating YAML files from templates..."

# Export variables from .env if it exists
if [ -f .env ]; then
  export $(cat .env | grep -v '#' | xargs)
fi

# Generate alertmanager.yml from template
envsubst < alertmanager.yml.template > alertmanager.yml

echo "YAML files generated successfully!"
echo "Starting services..."

# Start Docker Compose
docker compose up -d

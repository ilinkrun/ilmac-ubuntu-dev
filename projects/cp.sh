#!/bin/bash

# ca.sh - Create application directory structure
# Usage: ./ca.sh <app-name>

if [ $# -ne 1 ]; then
    echo "Usage: $0 <app-name>"
    echo "Example: $0 bid-notice"
    exit 1
fi

APP_NAME="$1"

echo "Creating directory structure for: $APP_NAME"

# Main directories
# mkdir -p "$APP_NAME/backend"
mkdir -p "$APP_NAME/frontend"
mkdir -p "$APP_NAME/database"
mkdir -p "$APP_NAME/logs"

# Backup directories
mkdir -p "$APP_NAME/_backups/backend"
mkdir -p "$APP_NAME/_backups/frontend"
mkdir -p "$APP_NAME/_backups/database"

# Drafts directories
mkdir -p "$APP_NAME/_drafts/backend"
mkdir -p "$APP_NAME/_drafts/frontend"
mkdir -p "$APP_NAME/_drafts/database"

# Documentation directories
mkdir -p "$APP_NAME/_docs/claudecode"
mkdir -p "$APP_NAME/_docs/planning"
mkdir -p "$APP_NAME/_docs/backend"
mkdir -p "$APP_NAME/_docs/frontend"
mkdir -p "$APP_NAME/_docs/database"

echo "Directory structure created successfully!"
echo ""
echo "Created directories:"
tree "$APP_NAME" 2>/dev/null || find "$APP_NAME" -type d | sort
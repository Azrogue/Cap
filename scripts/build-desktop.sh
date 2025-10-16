#!/bin/bash

# Build script for Cap Desktop
# Usage: ./scripts/build-desktop.sh [target] [mode]

set -e

# Default values
TARGET=${1:-"aarch64-pc-windows-msvc"}
MODE=${2:-"debug"}

echo "🔨 Building Cap Desktop"
echo "Target: $TARGET"
echo "Mode: $MODE"
echo "---"

# Check if we are in the right directory
if [ ! -f "package.json" ]; then
    echo "Error: Not in the project root. Run from project root."
    exit 1
fi

# Check dependencies
if ! command -v pnpm &> /dev/null; then
    echo "pnpm not found. Installing..."
    npm install -g pnpm@8.10.5
fi

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    pnpm install
fi

# Setup environment
echo "Setting up environment..."
pnpm cap-setup

# Create .env file if it does not exist
if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    cat > .env << ENDOF
VITE_ENVIRONMENT=production
CAP_DESKTOP_SENTRY_URL=https://6a3b6a09e6ae976c2ad6fff710e88748@o4506859771527168.ingest.us.sentry.io/4508330917101568
NEXT_PUBLIC_WEB_URL=https://cap.so
NEXTAUTH_URL=https://cap.so
NEXT_PUBLIC_CAP_AWS_REGION=us-east-1
NEXT_PUBLIC_CAP_AWS_BUCKET=cap-prod
ENDOF
fi

# Build
echo "Building desktop app..."
cd apps/desktop
pnpm tauri build --target $TARGET --$MODE --no-bundle

echo "Build completed!"
echo "Output location: apps/desktop/src-tauri/target/$TARGET/$MODE/bundle/"

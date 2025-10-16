#!/bin/bash

# Check build environment for Cap Desktop

echo "🔍 Checking Cap Desktop Build Environment"
echo "========================================="

# Check Rust
if command -v cargo &> /dev/null; then
    RUST_VERSION=$(cargo --version | cut -d' ' -f2)
    echo "✅ Rust: $RUST_VERSION"
    
    # Check Windows targets
    if rustup target list --installed | grep -q "aarch64-pc-windows-msvc"; then
        echo "✅ Windows ARM64 target installed"
    else
        echo "❌ Windows ARM64 target missing. Run: rustup target add aarch64-pc-windows-msvc"
    fi
    
    if rustup target list --installed | grep -q "x86_64-pc-windows-msvc"; then
        echo "✅ Windows x64 target installed"
    else
        echo "❌ Windows x64 target missing. Run: rustup target add x86_64-pc-windows-msvc"
    fi
else
    echo "❌ Rust not found. Install from https://rustup.rs/"
fi

echo ""

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✅ Node.js: $NODE_VERSION"
    
    # Check if version is 20+
    NODE_MAJOR=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_MAJOR" -ge 20 ]; then
        echo "✅ Node.js version meets requirements (20+)"
    else
        echo "⚠️ Node.js version is below 20, may cause issues"
    fi
else
    echo "❌ Node.js not found. Install Node.js 20+"
fi

echo ""

# Check pnpm
if command -v pnpm &> /dev/null; then
    PNPM_VERSION=$(pnpm --version)
    echo "✅ pnpm: $PNPM_VERSION"
    
    # Check if version is 8.10.5+
    PNPM_MAJOR=$(pnpm --version | cut -d'.' -f1)
    PNPM_MINOR=$(pnpm --version | cut -d'.' -f2)
    if [ "$PNPM_MAJOR" -gt 8 ] || ([ "$PNPM_MAJOR" -eq 8 ] && [ "$PNPM_MINOR" -ge 10 ]); then
        echo "✅ pnpm version meets requirements (8.10.5+)"
    else
        echo "⚠️ pnpm version is below 8.10.5, may cause issues"
    fi
else
    echo "❌ pnpm not found. Install with: npm install -g pnpm@8.10.5"
fi

echo ""

# Check project structure
if [ -f "package.json" ]; then
    echo "✅ package.json found"
else
    echo "❌ package.json not found. Not in project root?"
fi

if [ -d "apps/desktop" ]; then
    echo "✅ apps/desktop directory found"
    
    if [ -f "apps/desktop/package.json" ]; then
        echo "✅ Desktop package.json found"
    else
        echo "❌ Desktop package.json not found"
    fi
    
    if [ -f "apps/desktop/src-tauri/Cargo.toml" ]; then
        echo "✅ Tauri Cargo.toml found"
    else
        echo "❌ Tauri Cargo.toml not found"
    fi
else
    echo "❌ apps/desktop directory not found"
fi

echo ""

# Check for common issues
if [ -d ".pnpm-store" ]; then
    echo "✅ pnpm store directory exists"
else
    echo "⚠️ .pnpm-store directory missing, run pnpm install"
fi

if [ -d "node_modules" ]; then
    echo "✅ node_modules directory exists"
else
    echo "⚠️ node_modules directory missing, run pnpm install"
fi

echo ""

# Check environment variables
if [ -f ".env" ]; then
    echo "✅ .env file exists"
    
    # Check for required variables
    if grep -q "VITE_ENVIRONMENT" .env; then
        echo "✅ VITE_ENVIRONMENT configured"
    else
        echo "⚠️ VITE_ENVIRONMENT not in .env"
    fi
else
    echo "⚠️ .env file missing, run pnpm env-setup"
fi

echo ""
echo "Build environment check completed! 🎉"

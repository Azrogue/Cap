# Build Guide for Cap Desktop

## Prerequisites

Follow the installation requirements in [CONTRIBUTING.md](CONTRIBUTING.md):

- Node.js 20+
- Rust 1.88.0+
- pnpm 8.10.5+

## Quick Setup

```bash
# Install dependencies
pnpm install

# Setup environment
pnpm cap-setup

# Create environment file
pnpm env-setup

# Check build environment
./scripts/check-build-env.sh
```

## Building Locally

### Windows ARM64 (cross-compilation from Linux/macOS)

```bash
# Debug build
./scripts/build-desktop.sh aarch64-pc-windows-msvc debug

# Release build
./scripts/build-desktop.sh aarch64-pc-windows-msvc release
```

### Other Targets

```bash
# Windows x64
./scripts/build-desktop.sh x86_64-pc-windows-msvc release

# macOS x64
./scripts/build-desktop.sh x86_64-apple-darwin release

# macOS ARM64 (Apple Silicon)
./scripts/build-desktop.sh aarch64-apple-darwin release

# Linux x64
./scripts/build-desktop.sh x86_64-unknown-linux-gnu release
```

## Manual Build Commands

```bash
cd apps/desktop

# Development build (faster)
pnpm tauri dev

# Debug build
pnpm tauri build --debug --no-bundle

# Release build (optimized)
pnpm tauri build --release

# Specific target
pnpm tauri build --target aarch64-pc-windows-msvc --release --no-bundle
```

## Troubleshooting

### Common Issues

1. **Rust target not found**
   ```bash
   rustup target add aarch64-pc-windows-msvc
   rustup target add x86_64-pc-windows-msvc
   ```

2. **Node.js version too old**
   - Install Node.js 20+ from [nodejs.org](https://nodejs.org/)

3. **pnpm version issues**
   ```bash
   npm install -g pnpm@8.10.5
   ```

4. **Missing environment variables**
   ```bash
   pnpm env-setup
   ```

5. **Windows build fails**
   - Ensure Visual Studio Build Tools are installed
   - Try native Windows build instead of cross-compilation

### Cross-compilation Notes

Cross-compilation to Windows ARM64 from Linux/macOS can be complex. If you encounter issues:

1. Try building on Windows native (more reliable)
2. Use GitHub Actions for automated builds
3. Focus on x64 builds initially for faster iteration

### Windows-specific Build Requirements

From CONTRIBUTING.md:
- llvm, clang, and VCPKG must be installed on Windows
- MSVC toolchain should be properly configured

## GitHub Actions

The project includes automated build workflows in `.github/workflows/`:

- `build-desktop.yml`: Multi-platform builds
- `build-windows-arm64.yml`: Windows ARM64 specific builds
- `ci.yml`: Tests and quick build checks

## Artifacts

Build outputs are located in:
```
apps/desktop/src-tauri/target/{target}/{mode}/bundle/
```

Examples:
- `apps/desktop/src-tauri/target/aarch64-pc-windows-msvc/release/bundle/`
- `apps/desktop/src-tauri/target/x86_64-unknown-linux-gnu/debug/bundle/`

## Environment Variables

Key environment variables for builds:

```bash
VITE_ENVIRONMENT=production|development|test
CAP_DESKTOP_SENTRY_URL=...
NEXT_PUBLIC_WEB_URL=...
NEXTAUTH_URL=...
NEXT_PUBLIC_CAP_AWS_REGION=...
NEXT_PUBLIC_CAP_AWS_BUCKET=...
```

## Development Workflow

1. Make code changes
2. Run `./scripts/check-build-env.sh` to verify environment
3. Test with debug build: `./scripts/build-desktop.sh aarch64-pc-windows-msvc debug`
4. Create PR to test with GitHub Actions
5. Merge to main triggers production builds

## Release Process

1. Update version in `apps/desktop/src-tauri/Cargo.toml`
2. Create and push tag: `git tag v1.0.0 && git push origin v1.0.0`
3. GitHub Actions automatically builds and creates release

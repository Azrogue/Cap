# GitHub Actions Workflows

## Build Workflows

### Build Desktop Apps (`.github/workflows/build-desktop.yml`)
Builds Cap desktop app for all platforms:
- Windows x64 & ARM64 
- macOS x64 & ARM64
- Linux x64

**Triggers:**
- Push to `main`/`develop` branches
- Pull requests to `main`/`develop`
- Tags (for releases)

**Outputs:**
- Artifacts uploaded to GitHub Actions
- Release assets created from tags
- Automatic MSI/EXE generation for Windows

### CI Pipeline (`.github/workflows/ci.yml`)
Runs tests and checks:
- Linting
- Type checking
- Unit tests with database/services
- Quick build verification

## Local Development

To test builds locally:

```bash
# Install dependencies (following CONTRIBUTING.md)
pnpm install
pnpm cap-setup

# Build for current platform
cd apps/desktop
pnpm tauri build --debug

# Build for specific targets
pnpm tauri build --target x86_64-pc-windows-msvc --release
pnpm tauri build --target aarch64-pc-windows-msvc --release
```

## Release Process

1. Create and push a tag:
```bash
git tag v1.0.0
git push origin v1.0.0
```

2. GitHub Actions will:
   - Build for all platforms
   - Create release assets
   - Upload to GitHub Releases

## Environment Variables

The workflows set up these environment variables automatically:
- `VITE_ENVIRONMENT=production` (or `test` for CI)
- `CAP_DESKTOP_SENTRY_URL`
- `NEXT_PUBLIC_WEB_URL=https://cap.so`
- `NEXTAUTH_URL=https://cap.so`
- `NEXT_PUBLIC_CAP_AWS_REGION=us-east-1`
- `NEXT_PUBLIC_CAP_AWS_BUCKET=cap-prod`

## Debugging

- Check workflow runs in the "Actions" tab of GitHub
- Download artifacts from failed runs to investigate
- Logs show detailed build steps and environment info

# Mini Images Comparison

This repository compares different Docker image strategies for .NET and Node.js applications, focusing on image size, security, and build complexity.

## Overview

The project contains:
- `.NET 10` API application in `dotnet/HelloWorldApi/`
- `Node.js` API application in `nodejs/node-api/`

Multiple Dockerfile variants are provided for each runtime to compare:
- Traditional Alpine-based images
- Distroless images (Google, Chainguard)
- Custom optimized images

## Prerequisites

### Required Tools
- Docker (with BuildKit enabled)
- .NET 8 SDK (for building .NET app)
- Node.js 18+ (for building Node.js app)

### Optional Tools
- **Trivy** - for vulnerability scanning (`brew install trivy` or see [Trivy docs](https://aquasecurity.github.io/trivy/))
- **Docker Hub account** - required for DHI (Docker Hub Images) as they require authentication

## Building Images

### .NET Images

```bash
cd dotnet
./build.sh
```

This will build all .NET image variants and display their sizes.

### Node.js Images

```bash
cd nodejs
./build.sh
```

This will build all Node.js image variants and display their sizes.

## Image Variants

### .NET Variants
- `Dockerfile` - Standard Alpine-based image
- `Dockerfile.chainguard` - Chainguard distroless image
- `Dockerfile.chisel` - Custom chisel-based image
- `Dockerfile.chisel-curl` - Chisel with curl added
- `Dockerfile.dhi` - Docker Hub Image (requires authentication)

### Node.js Variants
- `Dockerfile` - Standard Alpine-based image
- `Dockerfile.chainguard` - Chainguard distroless image
- `Dockerfile.chainguard-curl` - Chainguard with curl
- `Dockerfile.dhi` - Docker Hub Image (requires authentication)
- `Dockerfile.google` - Google distroless image

## Scanning Images

Vulnerability scanning scripts are provided:

```bash
# Scan all images for a runtime
./scan.sh

# Get summary of scan results
./scan-sum.sh
```

## Key Findings

### Image Size Analysis

**Contrary to popular belief, distroless images don't always result in significantly smaller images** than well-optimized Alpine-based images. The key insights:

1. **What gets removed**: Traditional "fat" images contain ~3-5MB of unnecessary binaries and shell utilities. Removing these provides minimal size reduction.

2. **Runtime dominance**: For .NET and Node.js applications, the runtime itself (CLR/V10) represents the vast majority of the image size. The base OS layer becomes relatively insignificant.

3. **Library impact**: The real size differences come from:
   - **glibc vs musl**: Different C libraries have different sizes and compatibility
   - **Library stripping**: Removing unused system libraries can help, but modern runtimes bundle most dependencies
   - **Multi-stage builds**: Properly stripping debug symbols and unused assets matters more than base image choice

### Security Considerations

- **Distroless images** reduce attack surface by removing shells and package managers but does not mean removing CVEs
- **Chainguard images** provide regularly updated, minimal bases with SBOMs + SLA agreements for CVE
- **Alpine images** benefit from musl libc and small package set
- **DHI images** require Docker Hub authentication but provide official builds + SLA agreements for CVE aswell as being very tiny

### Build Complexity Tradeoffs

| Approach | Size Benefit | Security Benefit | Build Complexity |
|----------|-------------|------------------|------------------|
| Alpine | Baseline | Medium | Low |
| Distroless | Minimal | High | Medium |
| Chainguard | none | Very High | Medium |
| Custom (chisel) | Small | depends | High |

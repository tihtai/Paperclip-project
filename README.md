# Paperclip-project

Structured GitHub project layout with versioned releases and downloadable ZIP artifacts.

## Repository Structure

- `.github/workflows/release.yml`: Builds and publishes a ZIP artifact for each tagged release.
- `scripts/package-release.sh`: Creates a deterministic ZIP package for a version.
- `scripts/install.sh`: Installs latest or specific released version from GitHub Releases.
- `VERSION`: Current project version.
- `CHANGELOG.md`: Release notes and changes per version.

## Versioning

1. Update `VERSION`.
2. Update `CHANGELOG.md`.
3. Commit changes.
4. Tag release: `git tag vX.Y.Z`.
5. Push branch and tag: `git push origin main --tags`.

## Release ZIP Artifact

The GitHub Actions workflow runs on tags matching `v*` and uploads:

- `paperclip-project-vX.Y.Z.zip`

from repository content (excluding git internals and build cache).

## Installation

Install latest release to `./paperclip-project`:

```bash
bash scripts/install.sh
```

Install a specific version to a custom directory:

```bash
bash scripts/install.sh --version v0.1.0 --dir /opt/paperclip-project
```

You can also curl the installer directly from the repository:

```bash
curl -fsSL https://raw.githubusercontent.com/tihtai/Paperclip-project/main/scripts/install.sh | bash
```

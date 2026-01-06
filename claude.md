# Claude Project Guide

## Purpose

This is **cv.maxdaten.io** - a personal curriculum vitae (CV/resume) website for Jan-Philip Loos. The project generates professional CV/resume documents in multiple formats (PDF, HTML, DOCX) from Markdown source files.

Key features:
- **Multi-format output**: PDF (via LaTeX), DOCX, and HTML from single Markdown source
- **Multiple CV variants**: General CV and JavaScript/TypeScript-focused extract
- **Image optimization**: Automatic WebP conversion for web performance
- **Responsive HTML**: Dark/light theme toggle with modern CSS
- **Automated publishing**: GitHub Actions CI/CD to GitHub Pages

## Technology Stack

| Category | Technologies |
|----------|--------------|
| **Markup** | Markdown with LaTeX macros |
| **Document Generation** | Pandoc, LaTeX/TeXLive |
| **Build Automation** | Just (task runner) |
| **Dev Environment** | Nix, devenv.sh, direnv |
| **Image Processing** | ImageMagick (WebP conversion) |
| **CI/CD** | GitHub Actions, Cachix |
| **Deployment** | GitHub Pages |
| **QA** | Lychee link checker, smoke tests |
| **Analytics** | Plausible (privacy-friendly) |

## Build & Deploy

### Prerequisites

The project uses Nix for reproducible builds. With `direnv` installed, the environment loads automatically.

### Build Commands (via Just)

```bash
just build          # Full build: optimize images + generate all formats
just pages          # Generate CV files (PDF, DOCX, HTML)
just optimize-images # Convert source images to optimized WebP
just watch          # Watch for changes and auto-rebuild
just clean          # Remove build artifacts
just image-stats    # Show image size comparisons
```

### CI/CD Pipeline

**main.yml** - Build & Deploy:
- Triggers on push to `master`
- Builds project via `devenv shell build`
- Deploys to GitHub Pages

**smoketest.yml** - Health Checks:
- Runs daily and after deployments
- Verifies HTTP 200 response
- Validates expected content
- Checks all links with Lychee

## Project Structure

```
cv.maxdaten.io/
├── src/
│   ├── cv/                        # CV content (Markdown)
│   │   ├── curriculum-vitae.md    # Full general CV
│   │   └── curriculum-vitae-javascript.md  # JS/TS focused extract
│   ├── templates/                 # Document templates
│   │   ├── template.html          # HTML template (Pandoc)
│   │   ├── template.css           # CSS styling (light/dark mode)
│   │   └── template.tex           # LaTeX template for PDF
│   └── img/                       # Source images
│
├── build/                         # Generated output (gitignored)
│   ├── cv/                        # Generated CV files (PDF, DOCX, HTML)
│   ├── img/                       # Optimized images (WebP)
│   └── index.html                 # Landing page
│
├── .github/
│   └── workflows/
│       ├── main.yml               # Build & deploy workflow
│       └── smoketest.yml          # Health check tests
│
├── justfile                       # Build tasks & recipes
├── devenv.nix                     # Development environment config
├── devenv.yaml                    # devenv settings
├── .envrc                         # direnv configuration
├── CNAME                          # GitHub Pages domain
└── markdownlint.yaml              # Markdown linting rules
```

### Key Files

- **`src/cv/*.md`** - CV content in Markdown format
- **`src/templates/`** - Pandoc templates for each output format
- **`justfile`** - All build recipes and automation tasks
- **`devenv.nix`** - Nix-based development environment with all dependencies

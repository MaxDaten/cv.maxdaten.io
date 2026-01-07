# CV build configuration

build_dir := "./build/cv"
src_dir := "./src/cv"
template_dir := "./src/templates"
img_src_dir := "./src/img"
img_build_dir := "./build/img"

# Image optimization settings

profile_size := "400"
profile_quality := "85"
pandoc_options := "--standalone --from markdown+latex_macros"
pandoc_pdf_options := "--template " + template_dir + "/template.tex"
pandoc_html_options := "--embed-resources --resource-path=build --write html5 --css " + template_dir + "/template.css --template " + template_dir + "/template.html --verbose"
pandoc_docx_options := "--write docx"

# CV variants: source_file:output_name

cv_variants := "curriculum-vitae:jan-philip-loos-curriculum-vitae curriculum-vitae-javascript:jan-philip-loos-javascript-typescript"

# Default recipe
default: build

# Build all pages (with image optimization and OG images)
build: optimize-images og-images pages

# Build core assets only (no Playwright/shot-scraper - for CI compatibility)
build-core: optimize-images pages

# Generate a single CV in all formats (pdf, docx, html)
[private]
cv source output:
    @echo "Generating {{ output }}..."
    pandoc {{ pandoc_options }} {{ pandoc_pdf_options }} --output {{ build_dir }}/{{ output }}.pdf {{ src_dir }}/{{ source }}.md
    pandoc {{ pandoc_options }} {{ pandoc_docx_options }} --output {{ build_dir }}/{{ output }}.docx {{ src_dir }}/{{ source }}.md
    pandoc {{ pandoc_options }} {{ pandoc_html_options }} --output {{ build_dir }}/{{ output }}.html {{ src_dir }}/{{ source }}.md

# Generate all curriculum-vitae files
pages:
    mkdir -p {{ build_dir }}

    @for variant in {{ cv_variants }}; do \
        source=$(echo "$variant" | cut -d: -f1); \
        output=$(echo "$variant" | cut -d: -f2); \
        just cv "$source" "$output"; \
    done

    cp -f {{ build_dir }}/jan-philip-loos-curriculum-vitae.html build/index.html

    @echo "Copy files to misc"
    mkdir -p {{ build_dir }}/misc
    cp -f {{ build_dir }}/jan-philip-loos-curriculum-vitae.pdf {{ build_dir }}/misc/cv.jan.philip.loos.en.pdf

    cp -r .well-known build
    cp CNAME build

# Clean build artifacts
clean:
    rm -rf build

# Install (no-op)
install:
    @echo "done"

# Watch for changes and rebuild
watch:
    nix-shell --pure --run 'watchexec --ignore build just pages'

# Optimize images for web (converts all to WebP)
optimize-images:
    @echo "Optimizing images to WebP..."
    mkdir -p {{ img_build_dir }}
    @for f in {{ img_src_dir }}/*; do \
        if [ -f "$f" ]; then \
            name=$(basename "$f" | sed 's/\.[^.]*$//'); \
            echo "  $f -> $name.webp"; \
            magick "$f" -resize '{{ profile_size }}x{{ profile_size }}>' -strip -quality {{ profile_quality }} "{{ img_build_dir }}/$name.webp"; \
        fi \
    done
    @echo "Image optimization complete!"

# Generate OpenGraph preview image for social sharing
og-images:
    @echo "Generating OpenGraph preview image..."
    mkdir -p {{ img_build_dir }}
    shot-scraper shot {{ template_dir }}/og-card.html -w 1200 -h 630 -o {{ img_build_dir }}/og-card.png
    @echo "OG image generated at {{ img_build_dir }}/og-card.png"
    @ls -lh {{ img_build_dir }}/og-card.png

# Show image sizes (before/after comparison)
image-stats:
    @echo "=== Source Images ({{ img_src_dir }}) ==="
    @du -h {{ img_src_dir }}/* 2>/dev/null || echo "No source images found"
    @echo ""
    @echo "=== Optimized Images ({{ img_build_dir }}) ==="
    @du -h {{ img_build_dir }}/* 2>/dev/null || echo "No optimized images found (run 'just optimize-images' first)"

# Screenshot settings

screenshot_dir := "./build/screenshots"

# Capture design screenshots at multiple viewports and themes

# Note: Dark mode colors may appear slightly brighter due to Playwright limitation.
screenshots:
    @echo "Capturing design screenshots..."
    mkdir -p {{ screenshot_dir }}
    @sed "s|APP_PATH|$(pwd)|g" screenshots.yml > /tmp/screenshots-resolved.yml
    shot-scraper multi /tmp/screenshots-resolved.yml --retina
    @rm /tmp/screenshots-resolved.yml
    @echo "Screenshots saved to {{ screenshot_dir }}"
    @ls -la {{ screenshot_dir }}

# Open screenshots folder
open-screenshots:
    open {{ screenshot_dir }}

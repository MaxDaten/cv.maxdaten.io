# CV build configuration
build_dir := "./build/cv"
src_dir := "./src/cv"
template_dir := "./src/templates"
img_src_dir := "./src/img"
img_build_dir := "./build/img"

# Image optimization settings
profile_size := "400"  # Profile picture max dimension in pixels
profile_quality := "85"  # JPEG quality (0-100)

pandoc_options := "--standalone --from markdown+latex_macros"
pandoc_pdf_options := "--template " + template_dir + "/template.tex"
pandoc_html_options := "--embed-resources --write html5 --css " + template_dir + "/template.css --template " + template_dir + "/template.html --verbose"
pandoc_docx_options := "--write docx"

# Default recipe
default: build

# Build all pages (with image optimization)
build: optimize-images pages

# Generate curriculum-vitae files
pages:
    mkdir -p {{build_dir}}

    @echo "Generate curriculum-vitae files"
    pandoc {{pandoc_options}} {{pandoc_pdf_options}} --output {{build_dir}}/jan-philip-loos-curriculum-vitae.pdf {{src_dir}}/curriculum-vitae.md
    pandoc {{pandoc_options}} {{pandoc_docx_options}} --output {{build_dir}}/jan-philip-loos-curriculum-vitae.docx {{src_dir}}/curriculum-vitae.md
    pandoc {{pandoc_options}} {{pandoc_html_options}} --output {{build_dir}}/jan-philip-loos-curriculum-vitae.html {{src_dir}}/curriculum-vitae.md

    @echo "Generate JavaScript/TypeScript extract"
    pandoc {{pandoc_options}} {{pandoc_pdf_options}} --output {{build_dir}}/jan-philip-loos-javascript-typescript.pdf {{src_dir}}/curriculum-vitae-javascript.md
    pandoc {{pandoc_options}} {{pandoc_docx_options}} --output {{build_dir}}/jan-philip-loos-javascript-typescript.docx {{src_dir}}/curriculum-vitae-javascript.md
    pandoc {{pandoc_options}} {{pandoc_html_options}} --output {{build_dir}}/jan-philip-loos-javascript-typescript.html {{src_dir}}/curriculum-vitae-javascript.md

    cp -f {{build_dir}}/jan-philip-loos-curriculum-vitae.html build/index.html

    @echo "Copy files to misc"
    mkdir -p {{build_dir}}/misc
    cp -f {{build_dir}}/jan-philip-loos-curriculum-vitae.pdf {{build_dir}}/misc/cv.jan.philip.loos.en.pdf

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
    mkdir -p {{img_build_dir}}
    @for f in {{img_src_dir}}/*; do \
        if [ -f "$f" ]; then \
            name=$(basename "$f" | sed 's/\.[^.]*$//'); \
            echo "  $f -> $name.webp"; \
            magick "$f" -resize '{{profile_size}}x{{profile_size}}>' -strip -quality {{profile_quality}} "{{img_build_dir}}/$name.webp"; \
        fi \
    done
    @echo "Image optimization complete!"

# Show image sizes (before/after comparison)
image-stats:
    @echo "=== Source Images ({{img_src_dir}}) ==="
    @du -h {{img_src_dir}}/* 2>/dev/null || echo "No source images found"
    @echo ""
    @echo "=== Optimized Images ({{img_build_dir}}) ==="
    @du -h {{img_build_dir}}/* 2>/dev/null || echo "No optimized images found (run 'just optimize-images' first)"

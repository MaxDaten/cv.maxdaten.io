# CV build configuration
build_dir := "./build/cv"
src_dir := "./src/cv"
template_dir := "./src/templates"

pandoc_options := "--standalone --from markdown+latex_macros"
pandoc_pdf_options := "--template " + template_dir + "/template.tex"
pandoc_html_options := "--embed-resources --write html5 --css " + template_dir + "/template.css --template " + template_dir + "/template.html --verbose"
pandoc_docx_options := "--write docx"

# Default recipe
default: build

# Build all pages
build: pages

# Generate curriculum-vitae files
pages:
    mkdir -p {{build_dir}}

    @echo "Generate curriculum-vitae files"
    pandoc {{pandoc_options}} {{pandoc_pdf_options}} --output {{build_dir}}/jan-philip-loos-curriculum-vitae.pdf {{src_dir}}/curriculum-vitae.md
    pandoc {{pandoc_options}} {{pandoc_docx_options}} --output {{build_dir}}/jan-philip-loos-curriculum-vitae.docx {{src_dir}}/curriculum-vitae.md
    pandoc {{pandoc_options}} {{pandoc_html_options}} --output {{build_dir}}/jan-philip-loos-curriculum-vitae.html {{src_dir}}/curriculum-vitae.md

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

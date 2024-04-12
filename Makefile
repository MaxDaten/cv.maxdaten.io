.PHONY: build update-nixpkgs clean watch

BUILD_DIR := ./build/cv
SRC_DIR := ./src/cv
TEMPLATE_DIR := ./src/templates

PANDOC_OPTIONS := --standalone --from markdown+latex_macros
PANDOC_PDF_OPTIONS := --template $(TEMPLATE_DIR)/template.tex
PANDOC_HTML_OPTIONS := --embed-resources --write html5 --css $(TEMPLATE_DIR)/template.css --template $(TEMPLATE_DIR)/template.html --verbose
PANDOC_DOCX_OPTIONS := --write docx

build:
	make pages

pages:
	mkdir -p $(BUILD_DIR)

	@echo "Generate curriculum-vitae files"
	pandoc $(PANDOC_OPTIONS) $(PANDOC_PDF_OPTIONS) --output $(BUILD_DIR)/jan-philip-loos-curriculum-vitae.pdf $(SRC_DIR)/curriculum-vitae.md
	pandoc $(PANDOC_OPTIONS) $(PANDOC_DOCX_OPTIONS) --output $(BUILD_DIR)/jan-philip-loos-curriculum-vitae.docx $(SRC_DIR)/curriculum-vitae.md
	pandoc $(PANDOC_OPTIONS) $(PANDOC_HTML_OPTIONS) --output $(BUILD_DIR)/jan-philip-loos-curriculum-vitae.html $(SRC_DIR)/curriculum-vitae.md

	cp -f $(BUILD_DIR)/jan-philip-loos-curriculum-vitae.html build/index.html

	echo "Copy files to misc"
	mkdir -p $(BUILD_DIR)/misc
	cp -f $(BUILD_DIR)/jan-philip-loos-curriculum-vitae.pdf $(BUILD_DIR)/misc/cv.jan.philip.loos.en.pdf

	cp -r .well-known build
	cp CNAME build

clean:
	rm -rf build

install:
	echo "done"

watch:
	nix-shell --pure --run 'watchexec --ignore build make pages'

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

	@echo "Generate curriculum-vitae-short files"
	pandoc $(PANDOC_OPTIONS) $(PANDOC_PDF_OPTIONS) --output $(BUILD_DIR)/curriculum-vitae-short.pdf $(SRC_DIR)/curriculum-vitae-short.md
	pandoc $(PANDOC_OPTIONS) $(PANDOC_DOCX_OPTIONS) --output $(BUILD_DIR)/curriculum-vitae-short.docx $(SRC_DIR)/curriculum-vitae-short.md
	pandoc $(PANDOC_OPTIONS) $(PANDOC_HTML_OPTIONS) --output $(BUILD_DIR)/curriculum-vitae-short.html $(SRC_DIR)/curriculum-vitae-short.md

	cp -f $(BUILD_DIR)/curriculum-vitae-short.html build/index.html

	cp -r .well-known build
	cp CNAME build

clean:
	rm -rf build

install:
	echo "done"

watch:
	nix-shell --pure --run 'watchexec --ignore build make pages'

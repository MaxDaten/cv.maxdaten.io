.PHONY: build update-nixpkgs clean watch

build:
	make pages

pages:
	mkdir -p build/cv

	pandoc \
		--output ./build/cv/curriculum-vitae.pdf \
		--standalone \
		--include-in-header ./src/templates/base.tex \
		--template ./src/templates/template.latex \
		./src/cv/curriculum-vitae.md
	pandoc \
		--embed-resources --standalone \
		--write html5 \
		--output ./build/cv/curriculum-vitae.html \
		--css ./src/templates/template.css \
		--template ./src/templates/template.html \
		--verbose \
		./src/cv/curriculum-vitae.md
	pandoc \
		--standalone \
		--write docx \
		--output ./build/cv/curriculum-vitae.docx \
		./src/cv/curriculum-vitae.md

	cp -f ./build/cv/curriculum-vitae.html build/index.html

	cp -r .well-known build
	cp CNAME build

clean:
	rm -rf build

install:
	echo "done"

watch:
	nix-shell --pure --run 'watchexec --ignore build make pages'

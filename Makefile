.PHONY: all build clean doc repl fmt deps

all: build doc

build:
	dune build

doc:
	dune build @doc
	pdflatex doc/postem_book.tex
	rm postem_book.aux
	rm postem_book.log
	rm postem_book.toc
	mkdir doc/build
	mv postem_book.pdf doc/build/

clean:
	dune clean
	rm -rf doc/build

repl: build
	dune utop

fmt:
	dune build @fmt --auto-promote | exit 0

deps:
	dune external-lib-deps --missing @@default

install: build
	sudo install -m 755 "${PWD}/_build/default/bin/postem.exe" /usr/local/bin/postem

uninstall:
	sudo rm /usr/local/bin/postem

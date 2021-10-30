.PHONY: all build clean doc repl fmt deps

all: build doc

build:
	dune build

doc:
	dune build @doc-private
	pdflatex doc/book/postem_book.tex
	rm postem_book.aux
	rm postem_book.log
	rm postem_book.toc
	mkdir doc/build
	mv postem_book.pdf doc/build

clean:
	dune clean
	rm -rf doc/build

repl:
	dune utop

fmt:
	-dune build @fmt --auto-promote

deps:
	dune external-lib-deps --missing @@default

install:
	dune build @install
	dune install

uninstall:
	dune uninstall

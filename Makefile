.PHONY: all build clean repl fmt deps

all: build doc

build:
	dune build

doc:
	dune build @doc
	pdflatex doc/postem_book.tex

clean:
	dune clean

repl: all
	dune utop

fmt:
	dune build @fmt --auto-promote

deps:
	dune external-lib-deps --missing @@default

install: all
	sudo install -m 755 "${PWD}/_build/default/bin/postem.exe" /usr/local/bin/postem

uninstall:
	sudo rm /usr/local/bin/postem

.PHONY: all build clean repl fmt deps

all: build doc

build:
	dune build

doc:
	dune build @doc

clean:
	dune clean

repl: all
	dune utop

fmt:
	dune build @fmt --auto-promote

deps:
	dune external-lib-deps --missing @@default

install: all
	sudo cp "${PWD}/_build/default/bin/postem.exe" /usr/local/bin/;
	sudo mv /usr/local/bin/postem.exe /usr/local/bin/postem

uninstall:
	sudo rm /usr/local/bin/postem

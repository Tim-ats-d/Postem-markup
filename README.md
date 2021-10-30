# Postem

A fast and easy **notes taking** oriented **markup** language

## Abstracts

**Markdown** is pretty simple and powerful, but not suitable for note taking. **LaTeX** a very heavy syntax that makes it complicated to write  although very complete. **Postem** offers an in-between to quickly structure a text and compile it to other more conventional formats.

## Key Features

* **Lightweight:** a light syntax and a small number of marks.
* **Flexible:** it compiles to other famous markup languages such as **Markdown** and **HTML**.
* **Extensible:** it is very easy to create an expansion to customize the rendering.

#### Not yet implemented

* A Pandoc-repl like.
* Compilation to [**Pandoc**](https://github.com/jgm/pandoc) format
* Unicode support outside of unformat expression.

## Examples

This text marked in Postem:
```text
P == "Postem"

& The Postem book

&& Introduction

A long introduction paragraph
and its continuation.

Another one.

&& Abstracts

> A quotation of the author of the language explaining the reasons that led him to write P

&& Marks description

Unformat block %% Allows you to write text that will not be formatted.

Example %% {{Unformated # text & with many special char.}}

-- This mark is pretty usefull.
```
will be rendered in this (with default plain text mode enabled):
<details>
    <summary><b>Output</b></summary>

```text
The Postem book
***************

Introduction
============

A long introduction paragraph and its continuation.

Another one.

Abstracts
=========

 █ A quotation of the author of the language explaining the reasons that led him to write Postem

Marks description
=================

Unformat block
  | Allows you to write text that will not be formatted.

Example
  | Unformated # text & with many special char.

\-> This mark is pretty usefull.
```

</details>

## Usage

Install it:

```
$ make install
```

Run Postem:

```
$ postem bin/doc.post -s
```

## Documentation

### The Postem book

The Postem book contains the grammar specification and more.

It can be found in `doc/build` after running:

```
make doc
```

## Contributing

Pull requests, bug reports, and feature requests are welcome.

## License

- **GPL 3.0** or later. See [license](LICENSE) for more information.

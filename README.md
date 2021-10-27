# Postem

**Postem** is a fast and **easy notes taking** oriented **markup language**.

## Abstracts

**Markdown** is pretty interesting, but not suitable for note taking. **LaTeX** is too complicated to write although powerful. **Postem** offers an in-between to quickly structure a text and compile it to other more conventional formats.

## Features

* Expansions support

#### Not yet implemented

* Compilation to other famous markup languages.
* Compilation to [**Pandoc**](https://github.com/jgm/pandoc) format.
* Unicode support.

## Examples

This text marked in Postem:
```text
P == "Postem"

& The P book

&& Introduction

A long introduction text.

&& Abstracts

> A quotation of the author of the language explaining the reasons that led him to write P

&& Marks description

Unformat block %% Allows you to write text that will not be formatted.

Example %% {{{Unformated # text & with many special char.}}}

-- This mark is pretty usefull.
```
will be rendered in:
<details>
    <summary><b>Render</b></summary>

```text
The Postem book
***************

Introduction
============

A long introduction text.

Abstracts
=========

 █ A quotation of the author of the language explaining the reasons that led him to write Postem

Marks description
=================

Unformat block
  | Allows you to write text that will not be formatted.

Example
  | Unformated # text & with many special char

\-> This mark is pretty usefull.
```

</details>

## Installation

```
make install
postem --help
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

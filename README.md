# Postem

A lightweight WIP **markup** language designed for quick note taking.

## Abstracts

**Markdown** is pretty simple and powerful, but not suitable for note taking. **LaTeX** has a very heavy syntax that makes it complicated to write although very complete. **Postem** offers an in-between to quickly structure a text and compile it to other more conventional formats.

## Key Features

* **Lightweight:** a light syntax.
* **Flexible:** it compiles to other famous markup languages such as **AsciiDoc** and **Markdown**.
* **Extensible:** it is very easy to create an expansion to customize the rendering or extend available tags set using **OCaml**.

#### Not yet implemented

* Compilation to [**Pandoc**](https://github.com/jgm/pandoc) format

## Examples

This text marked in Postem:
```text
& Postem

&& Philosophy

P aims to be a lightweight markup language designed for note taking.
It is also intended to be easily extensible by allowing extension writing in OCaml.

&& Features

P supports alias definition and custom operator definition.

&& Builtins marks

There are six builtins title tags:
{{& for a level one title, && for a level two title, and this up to 6.}}

By the way, the line above is unformated because it is put between two curly brackets.
This avoids the need to individually escape each operator.

> There are also quotes

> On one or on
> several lines

-- The \-\- mark allows you to formulate a conclusion.
```
will be rendered in this (with default expansion enabled):
<details>
    <summary><b>Output</b></summary>

```text
I - Postem
##########

A) Philosophy
*************

Postem aims to be a lightweight markup language designed for note taking.
It is also intended to be easily extensible by allowing extension writing in OCaml.

B) Features
***********

Postem supports alias definition and custom operator definition.

C) Builtins marks
*****************

There are six builtins title tags:
& for a level one title, && for a level two title, and this up to 6.

By the way, the line above is unformated because it is put between two curly brackets.
This avoids the need to individually escape each operator.

 █ There are also quotes

 █ On one or on
 █ several lines

-> The -- mark allows you to formulate a conclusion.
```

</details>

## Getting started with Postem

See the [dedicated readme](doc/getting_started.md).

## Installing

Check for missing dependencies:
```
$ make deps
```

Then install Postem:
```
$ make install
```

This will install **Postem** (make it runnable) and man pages in the dedicated folders.

## Contributing

Pull requests, bug reports, and feature requests are welcome.

## License

- **GPL 3.0** or later. See [license](LICENSE) for more information.

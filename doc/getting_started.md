# Getting started

## Command line usage

### Basics

To simply print the result on stdout:
```bash
$ postem input
```

To compile a text marked in **Postem** from a file and write result `<output>`:
```bash
$ postem input -o output
```

### Expansions

**Postem** supports a rendering customization mechanism called expansions.

For a more detailed description of this feature, see the [dedicated readme](overview.md)

To set the expansion used for rendering:

```bash
$ postem -o output -e expansion_name
```
by default, the `default` extension is used.

To display on stdout the list of installed expansions and their description, pass the flag `-l`:

```
$ postem -l
```

### References

For a more precise description of command line usage, please refer to the manual page of **Postem**:

```bash
$ man postem
```

or do:

```bash
$ postem --help
```

## Use Postem as an OCaml library

Install **Postem** as a library:

```bash
$ cd Postem-markup
$ opam install .
```

Here is an example of how to get the rendering of a document from a text marked in **Postem**:
```ocaml
let input = "& Hello from Postem!"

let () =
  let result = Core.Compiler.from_str input (module Expansion.Default) in
  match result with
  | Ok output -> print_endline output
  | Error err -> prerr_endline err
```

Don't forget to add `postem` to the list of libraries used in your **Dune** stanza.

Many other functions to interact with **Postem** are documented [here](../src/core/compiler.mli).


## Syntaxic color for Postem

See the [dedicated readme](syntax_highlighting.md).

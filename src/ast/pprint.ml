open Ast_types

let whitespace i chr =
  String.make i
  @@
  match chr with
  | CarriageReturn -> '\r'
  | Newline -> '\n'
  | Tab -> '\t'
  | Space -> ' '
  | Unknown c -> c

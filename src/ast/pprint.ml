open Ast_types

let string_of_whitespace = function
  | CarriageReturn -> '\r'
  | Newline -> '\n'
  | Tab -> '\t'
  | Space -> ' '
  | Unknown c -> c

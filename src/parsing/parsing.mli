val parse_document :
  Lexing.lexbuf -> (Ast.Ast_types.expr Ast.Ast_types.document, string) result
(** [parse_document lexbuf] returns [Ok ast] if the parsing goes smoothly, [Error msg] otherwise. *)

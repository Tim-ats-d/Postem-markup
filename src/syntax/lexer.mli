exception Syntax_error of Sedlexing.lexbuf

val read : Sedlexing.lexbuf -> Parser.token
(** @raise Syntax_error *)

val read_debug : Sedlexing.lexbuf -> Parser.token
(** @raise Syntax_error *)

exception IllegalChar of Sedlexing.lexbuf

val read : Sedlexing.lexbuf -> Parser.token
(** @raise IllegalChar *)

val read_debug : Sedlexing.lexbuf -> Parser.token
(** @raise IllegalChar *)

(** {1 API} *)

val document :
  (Lexing.lexbuf -> Parser.token) ->
  Lexing.lexbuf ->
  Ast.Ast_types.expr Ast.Ast_types.element list

module Lexer : sig
  exception Syntax_error of Lexing.lexbuf

  val read : Lexing.lexbuf -> Parser.token
  (** @raise Syntax_error  *)
end

val parse_document :
  Lexing.lexbuf -> (Ast.Ast_types.expr Ast.Ast_types.document, string) result
(** [parse_document lexbuf] returns [Ok ast] if the parsing goes smoothly, [Error msg] otherwise. *)

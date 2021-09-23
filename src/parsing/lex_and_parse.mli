val error_position : Lexing.lexbuf -> string

val parse_with_error : Lexing.lexbuf -> (Ast.Ast_types.program, string) result

val parse_and_print : Lexing.lexbuf -> unit

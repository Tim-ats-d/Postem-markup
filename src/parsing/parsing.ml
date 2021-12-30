open Utils
module Lexer = Lexer

let document = Parser.document

let parse_document lexbuf =
  try Ok (Parser.document Lexer.read lexbuf) with
  | Lexer.Syntax_error { lex_curr_p; _ } ->
      Result.error
      @@ Error.of_position lex_curr_p
           ~msg:"character not allowed in source text"
           ~hint:"non-ascii characters must be placed in a unformat block."
  | Parser.Error -> Result.error @@ Error.of_lexbuf lexbuf ~msg:"syntax error"

open Utils

let parse_document lexbuf =
  try Ok (Parser.document Lexer.read lexbuf) with
  | Lexer.Syntax_error { lex_curr_p; _ } ->
      Error.of_position lex_curr_p ~msg:"character not allowed in source text"
        ~hint:"non-ascii characters must be placed in a unformat block"
      |> Result.error
  | Parser.Error -> Error.of_lexbuf lexbuf ~msg:"syntax error" |> Result.error

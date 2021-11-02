open Utils

let parse_document lexbuf =
  try Ok (Parser.document Lexer.read lexbuf) with
  | Lexer.Syntax_error (lexbuf, msg) ->
      Error_msg.of_lexbuf lexbuf ~msg |> Result.error
  | Parser.Error ->
      Error_msg.of_lexbuf lexbuf ~msg:"syntax error" |> Result.error

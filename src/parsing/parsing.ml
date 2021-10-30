open Utils

let parse_document lexbuf =
  try Ok (Parser.document Lexer.read lexbuf) with
  | Lexer.Error (lexbuf, msg) -> Error_msg.of_lexbuf lexbuf ~msg |> Result.error
  | Parser.Error | Failure _ ->
      Error_msg.of_lexbuf lexbuf ~msg:"syntax error" |> Result.error

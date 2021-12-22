open Utils

let current_pos lexbuf = snd @@ Sedlexing.lexing_positions lexbuf

let parse_document lexbuf =
  let lexer = Sedlexing.with_tokenizer Lexer.read_debug lexbuf
  and parser =
    MenhirLib.Convert.Simplified.traditional2revised Parser.document
  in
  try Ok (parser lexer) with
  | Lexer.Syntax_error lexbuf ->
      let cpos = current_pos lexbuf in
      Error.of_position cpos ~msg:"character not allowed in source text"
      |> Result.error
  | Parser.Error ->
      let cpos = current_pos lexbuf in
      Error.of_position cpos ~msg:"syntax error" |> Result.error

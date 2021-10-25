let print_error_position lexbuf =
  let open Lexing in
  let pos = lexbuf.lex_curr_p in
  Printf.sprintf "Line:%d Position:%d" pos.pos_lnum
    (pos.pos_cnum - pos.pos_bol + 1)

let parse_document lexbuf =
  try Ok (Parser.document Lexer.read lexbuf)
  with Parser.Error ->
    print_error_position lexbuf
    |> Printf.sprintf "%s: syntax error."
    |> Result.error

let print_error_position lexbuf =
  let open Lexing in
  let pos = lexbuf.lex_curr_p in
  Printf.sprintf "Line:%d Position:%d" pos.pos_lnum
    (pos.pos_cnum - pos.pos_bol + 1)

let parse_document lexbuf =
  try Ok (Parser.document (Lexer.read []) lexbuf) with
  | Lexer.Syntax_error msg ->
      Printf.sprintf "%s: %s." (print_error_position lexbuf) msg |> Result.error
  | Parser.Error ->
      Printf.sprintf "%s: syntax error." (print_error_position lexbuf)
      |> Result.error

let pprint_parsed_ast = Ast.Pprint.pprint_document

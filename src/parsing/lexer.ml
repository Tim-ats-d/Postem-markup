exception Syntax_error of Sedlexing.lexbuf

let lexeme = Sedlexing.Utf8.lexeme
let letter = [%sedlex.regexp? lu | ll | lt | lm | lo]
let math = [%sedlex.regexp? sm | sc | sk | so]
let number = [%sedlex.regexp? nd | nl | no]
let punct = [%sedlex.regexp? po]

(* let text = [%sedlex.regexp? letter | math | | math | number | punct] *)
let text = [%sedlex.regexp? letter | number | punct]
let op_char = [%sedlex.regexp? Chars "!#$%&'*+-<=>'@^_|~"]
let op = [%sedlex.regexp? Plus op_char]
let space = [%sedlex.regexp? zs]
let newline = [%sedlex.regexp? '\n' | "\r\n"]
let assign = [%sedlex.regexp? Opt space, "==", Opt space]
let string = [%sedlex.regexp? '"', Star any, '"']

let strip ~left ?(right = 0) str =
  String.sub str left @@ (String.length str - right - left)

let read lexbuf =
  let open Parser in
  match%sedlex lexbuf with
  | '\\', any ->
      let lexm = lexeme lexbuf in
      TEXT String.(sub lexm 1 @@ (length lexm - 1))
  | '[' -> LBRACKET
  | ']' -> RBRACKET
  | op -> OP (lexeme lexbuf)
  | Plus text -> TEXT (lexeme lexbuf)
  | Plus space -> WHITE (lexeme lexbuf)
  | newline ->
      Sedlexing.new_line lexbuf;
      NEWLINE (lexeme lexbuf)
  | eof -> EOF
  | _ -> raise @@ Syntax_error lexbuf

let read_debug lexbuf =
  let token = read lexbuf in
  print_endline
  @@ Parser.(
       function
       | NEWLINE n -> Printf.sprintf "NEWLINE:%s" n
       | TEXT t -> Printf.sprintf "TEXT:%s" t
       | WHITE w -> Printf.sprintf "WHITE:%s" w
       | OP o -> Printf.sprintf "OP:%s" o
       | LBRACKET -> "LBRACKET"
       | RBRACKET -> "RBRACKET"
       | EOF -> "EOF")
       token;
  token

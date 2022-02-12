exception Syntax_error of Sedlexing.lexbuf

let letter = [%sedlex.regexp? lu | ll | lt | lm | lo]
let math = [%sedlex.regexp? sm | sc | sk | so]
let number = [%sedlex.regexp? nd | nl | no]
let punct = [%sedlex.regexp? po]

(* let text = [%sedlex.regexp? letter | math | | math | number | punct] *)
let text = [%sedlex.regexp? letter | number | punct]
let op_char = [%sedlex.regexp? Chars "!#$%&'*+-<=>'@^_|~"]
let op = [%sedlex.regexp? Plus op_char]
let whitespace = [%sedlex.regexp? zs]
let newline = [%sedlex.regexp? '\n' | "\r\n"]
let lexeme = Sedlexing.Utf8.lexeme

let cut ?(right = 0) ~left str =
  String.(sub str left (length str - right - left))

let read buf =
  let open Parser in
  match%sedlex buf with
  | '\\', any -> TEXT (cut ~left:1 @@ lexeme buf)
  | '[' -> LBRACKET
  | ']' -> RBRACKET
  | op -> OP (lexeme buf)
  | "{{", Star any, "}}" -> UNFORMAT (cut ~left:2 ~right:2 @@ lexeme buf)
  | Plus text -> TEXT (lexeme buf)
  | Plus whitespace -> WHITE (lexeme buf)
  | newline ->
      Sedlexing.new_line buf;
      NEWLINE (lexeme buf)
  | eof -> EOF
  | _ -> raise @@ Syntax_error buf

let read_debug lexbuf =
  let token = read lexbuf in
  print_endline
  @@ Parser.(
       function
       | NEWLINE n -> Printf.sprintf "NEWLINE:%s" n
       | TEXT t -> Printf.sprintf "TEXT:%s" t
       | WHITE w -> Printf.sprintf "WHITE:%s" w
       | UNFORMAT u -> Printf.sprintf "UNFORMAT:%s" u
       | OP o -> Printf.sprintf "OP:%s" o
       | LBRACKET -> "LBRACKET"
       | RBRACKET -> "RBRACKET"
       | EOF -> "EOF")
       token;
  token

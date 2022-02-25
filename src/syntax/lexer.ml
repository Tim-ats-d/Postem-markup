exception IllegalChar of Sedlexing.lexbuf

let escape = [%sedlex.regexp? '\\', any]
let op_char = [%sedlex.regexp? Chars "!#$%&'*+-<=>'@^_|~"]
let op = [%sedlex.regexp? Plus op_char]
let unformat = [%sedlex.regexp? "{{", Star any, "}}"]
let white_char = [%sedlex.regexp? zs]
let white = [%sedlex.regexp? Plus white_char]

let text =
  [%sedlex.regexp? Plus (Compl (op_char | '\n' | white_char | '[' | ']'))]
(* TODO: Windows newline support (\r\n) *)

let newline = [%sedlex.regexp? '\n' | "\r\n"]
let lexeme = Sedlexing.Utf8.lexeme

let cut ?(right = 0) ~left str =
  String.(sub str left (length str - right - left))

let read buf =
  let open Parser in
  match%sedlex buf with
  | escape -> TEXT (cut ~left:1 @@ lexeme buf)
  | '[' -> LBRACKET
  | ']' -> RBRACKET
  | op -> OP (lexeme buf)
  | unformat -> UNFORMAT (cut ~left:2 ~right:2 @@ lexeme buf)
  | white -> WHITE (lexeme buf)
  | text -> TEXT (lexeme buf)
  | newline -> NEWLINE (lexeme buf)
  | eof -> EOF
  | _ -> raise @@ IllegalChar buf

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

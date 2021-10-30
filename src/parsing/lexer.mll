{
  open Parser
}

let alpha = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let ws = ['\r' '\t' ' ']

let ascii_char = alpha | digit | ['!' '"' '#' '$' '%' '&' ''' ')' '(' '*' '+' ',' '-' '.' '/' ':' ';' '<' '=' '>' '?' '@' '`' '~' ']' '[' '^' '_' '{' '|' '}']

let newline = '\n' | "\r\n"
let sep = (newline) (newline)+

let int = digit+
let text = (alpha) (ascii_char)*

rule read = parse
  | eof             { EOF }
  | ' '             { SPACE }
  | '\t'            { TAB }
  | '\r'            { CARRIAGERETURN }
  | '\n'            { Lexing.new_line lexbuf; NEWLINE }
  | sep as s        { for _ = 0 to String.length s - 1 do
                        Lexing.new_line lexbuf
                        done;
                        SEPARATOR }
  | text as t       { TEXT t }
  | int as i        { INT (int_of_string i) }
  | ws? "==" ws?    { ASSIGNMENT }
  | "{{"           { read_unformat (Buffer.create 17) lexbuf }
  | "!!"            { read_path (Buffer.create 17) lexbuf }
  | '"'             { read_string (Buffer.create 17) lexbuf }
  | "--" ws?        { CONCLUSION }
  | ws? "%%" ws?    { DEFINITION }
  | ('&'+ as h) ws? { HEADING (String.length h) }
  | ">" ws?         { QUOTATION }
  | _               { Lexing.lexeme lexbuf
                      |> Printf.sprintf "Character not allowed in source text: '%s'"
                      |> failwith }

and read_string buf = parse
  | '"'    { STRING (Buffer.contents buf) }
  | '\n'   { Lexing.new_line lexbuf; read_string buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_string buf lexbuf }

and read_unformat buf = parse
  | "}}"  { UNFORMAT (Buffer.contents buf) }
  | '\n'   { Lexing.new_line lexbuf; read_unformat buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_unformat buf lexbuf }

and read_path buf = parse
  | "!!"   { INCLUDE (Buffer.contents buf) }
  | '\n'   { Lexing.new_line lexbuf; read_path buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_path buf lexbuf }

{
  open Parser

  exception Syntax_error of Lexing.lexbuf * string
}

let alpha = ['a'-'z' 'A'-'Z']
let ws = ['\r' '\t' ' ']

let newline = '\n' | "\r\n"
let sep = (newline) (newline)+

let int = ['0'-'9']+
let ascii_char = ['!'-'~']

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
  | ".."            { let name = read_meta_name (Buffer.create 17) lexbuf
                      and text = read_meta (Buffer.create 17) lexbuf in
                      META (name, text) }
  | '"'             { read_string (Buffer.create 17) lexbuf }
  | "{{"            { read_unformat (Buffer.create 17) lexbuf }
  | "--" ws?        { CONCLUSION }
  | ws? "%%" ws?    { DEFINITION }
  | ('&'+ as h) ws? { HEADING (String.length h) }
  | ">" ws?         { QUOTATION }
  | _               { let msg =
                        Lexing.lexeme lexbuf
                        |> Printf.sprintf "character not allowed in source text: '%s'" in
                      raise (Syntax_error (lexbuf, msg)) }

and read_meta_name buf = parse
  | ws as w { if w = '\n' then Lexing.new_line lexbuf; Buffer.contents buf }
  | _ as c  { Buffer.add_char buf c; read_meta_name buf lexbuf }

and read_meta buf = parse
  | ".."   { Buffer.contents buf }
  | '\n'   { Lexing.new_line lexbuf;
             Buffer.add_char buf '\n';
             read_meta buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_meta buf lexbuf }

and read_string buf = parse
  | '"'    { STRING (Buffer.contents buf) }
  | '\n'   { Lexing.new_line lexbuf;
             Buffer.add_char buf '\n';
             read_string buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_string buf lexbuf }

and read_unformat buf = parse
  | "}}"  { UNFORMAT (Buffer.contents buf) }
  | '\n'   { Lexing.new_line lexbuf;
             Buffer.add_char buf '\n';
             read_unformat buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_unformat buf lexbuf }

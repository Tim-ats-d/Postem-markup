{
  open Parser

  exception Syntax_error of Lexing.lexbuf
}

let alpha = ['a'-'z' 'A'-'Z']
let ws = ['\r' '\t' ' ']

let newline = '\n' | "\r\n"
let sep = (newline) (newline)+

let ascii_char = ['!'-'?' 'A'-'~']
let latin1 = ['\161'-'\255']

let text = (alpha | latin1) (ascii_char | latin1)*

rule read = parse
  | eof                    { EOF }
  | '\n'                   { Lexing.new_line lexbuf; read lexbuf  }
  | sep as s               { for _ = 0 to String.length s - 1 do
                               Lexing.new_line lexbuf
                             done;
                             SEPARATOR }
  | ws* as s               { WHITESPACE s }
  | text as t              { TEXT t }
  | ws? "==" ws?           { ASSIGNMENT }
  | '@' (ascii_char+ as m) { METASINGLE m }
  | ".."                   { let name = read_metamark_name (Buffer.create 17) lexbuf
                            and text = read_metamark (Buffer.create 17) lexbuf in
                            METAARGS (name, text) }
  | '"'                    { read_string (Buffer.create 17) lexbuf }
  | "{{"                   { read_unformat (Buffer.create 17) lexbuf }
  | "--" ws?               { CONCLUSION }
  | ws? "%%" ws?           { DEFINITION }
  | ('&'+ as h) ws?        { HEADING (String.length h) }
  | ">" ws?                { QUOTATION }
  | _                      { raise (Syntax_error lexbuf) }

and read_metamark_name buf = parse
  | ws      { Buffer.contents buf }
  | newline { Lexing.new_line lexbuf; Buffer.contents buf}
  | _ as c  { Buffer.add_char buf c; read_metamark_name buf lexbuf }

and read_metamark buf = parse
  | ".."   { Buffer.contents buf }
  | '\n'   { Lexing.new_line lexbuf;
             Buffer.add_char buf '\n';
             read_metamark buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_metamark buf lexbuf }

and read_string buf = parse
  | '"'    { STRING (Buffer.contents buf) }
  | '\n'   { Lexing.new_line lexbuf;
             Buffer.add_char buf '\n';
             read_string buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_string buf lexbuf }

and read_unformat buf = parse
  | "}}"   { UNFORMAT (Buffer.contents buf) }
  | '\n'   { Lexing.new_line lexbuf;
             Buffer.add_char buf '\n';
             read_unformat buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_unformat buf lexbuf }

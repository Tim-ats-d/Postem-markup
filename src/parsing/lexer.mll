{
open Lexing
open Parser

exception Syntax_error of string

let next_line lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
               pos_lnum = pos.pos_lnum + 1
    }
}

let alpha = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let symbol = ['!'-'/' ':'-'@' '['-'`' '{'-'~']
let ws = ['\r' '\t' ' ']

let newline = '\n' | "\r\n"
let sep = (newline) (newline)+

let int = digit+
let text = (alpha) (alpha|digit|symbol)*


rule read acc = parse
  | eof { EOF }
  | "--" { let c = read_line (CONCLUSION :: acc) (Buffer.create 17) lexbuf in
           read (c :: acc) lexbuf }
  | '&'+ as lvl { let h = read_line (HEADING (String.length lvl) :: acc) (Buffer.create 17) lexbuf in
                  read (h :: acc) lexbuf }
  | '>' { let q = read_line (QUOTATION :: acc) (Buffer.create 17) lexbuf in
          read (q :: acc ) lexbuf }
  | "" { let t = read_line acc (Buffer.create 17) lexbuf in
         read (t :: acc) lexbuf }

and read_line acc buf = parse
  | eof { EOF }
  | int as i { INT (int_of_string i) }
  | ' ' { SPACE }
  | '\t' { TAB }
  | '\r' { CARRIAGERETURN }
  | '\n' { next_line lexbuf; NEWLINE }
  | "!!" { let incl = read_include (Buffer.create 17) lexbuf in
           read_line (incl :: acc) buf lexbuf
         }
  | _ as c { Buffer.add_char buf c; read_line acc buf lexbuf }

and read_include buf = parse
  | "!!"   { INCLUDE (Buffer.contents buf)}
  | '\n'   { Lexing.new_line lexbuf; read_include buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_include buf lexbuf }


(*
rule read = parse
  | eof                 { EOF }
  | ' '                 { SPACE }
  | '\t'                { TAB }
  | '\r'                { CARRIAGERETURN }
  | '\n'                { next_line lexbuf; NEWLINE }
  | sep as s            { for _ = 0 to String.length s - 1 do
                           next_line lexbuf
                         done;
                         SEPARATOR }
  | text as t           { TEXT t }
  | int as i            { INT (int_of_string i) }
  | ws? "==" ws?        { ASSIGNMENT }
  | "{{{"               { read_unformat (Buffer.create 17) lexbuf }
  | "!!"                { read_path (Buffer.create 17) lexbuf }
  | ws? "--" ws?            { CONCLUSION }
  | ws? "%%" ws?        { DEFINITION }
  | ws? ('&'+ as h) ws? { HEADING (String.length h) }
  | ws? ">" ws?         { QUOTATION }

and read_string buf = parse
  | '"'    { ALIAS_VALUE (Buffer.contents buf) }
  | '\n'   { Lexing.new_line lexbuf; read_path buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_string buf lexbuf }

and read_unformat buf = parse
  | "}}}"  { UNFORMAT (Buffer.contents buf)}
  | '\n'   { Lexing.new_line lexbuf; read_unformat buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_unformat buf lexbuf }

and read_path buf = parse
  | "!!"   { INCLUDE (Buffer.contents buf)}
  | '\n'   { Lexing.new_line lexbuf; read_path buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_path buf lexbuf } *)

{
open Lexing
open Parser

exception Error of string

let next_line lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = pos.pos_cnum;
               pos_lnum = pos.pos_lnum + 1
    }
}

let newline = '\r' | '\n' | "\r\n"
let separator = newline newline

rule line =
  parse
  (* Normal case: one line, no eof. *)
  | ([^'\n']* separator) as line { Some line, true }

  (* Normal case: no data, eof. *)
  | eof                             { None, false }

  (* Special case: some data but missing '\n', then eof.
   Consider this as the last line, and add the missing '\n'. *)
  | ([^'\n']+ as line) eof          { Some (line ^ "\n"), false }

and read = parse
| [' ' '\t']
  { read lexbuf }
| ['0'-'9']+ as i
  { INT (int_of_string i) }

| separator  { next_line lexbuf; read lexbuf }
(* | '"'        { read_string (Buffer.create 17) lexbuf } *)
| _          { raise (Error ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }
| eof        { EOF }

(*
and read_string buf =
  parse
  | '"'               { STRING (Buffer.contents buf) }
  | newline           { Buffer.add_char buf '\n'; read_string buf lexbuf }
  | [^ '"' ]
    { Buffer.add_string buf (Lexing.lexeme lexbuf);
      read_string buf lexbuf
    }
  | _
    { raise (Syntax_error ("Illegal string character: " ^ Lexing.lexeme lexbuf)) }
  | eof               { raise (Syntax_error ("String is not terminated")) } *)

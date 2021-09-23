open Printf
open Lexer
open Lexing

let error_position lexbuf =
  let pos = lexbuf.lex_curr_p in
  sprintf "%s, line %d, characters %d" pos.pos_fname pos.pos_lnum
    (pos.pos_cnum - pos.pos_bol + 1)

let parse_and_print line =
  let linebuf = Lexing.from_string line in
  let open Printf in
  try Parser.prog Lexer.line linebuf |> printf "%s" with
  | Lexer.Error msg -> eprintf "%s: %s\n" (error_position linebuf) msg
  | Parser.Error -> eprintf "%s\nError: Syntax error\n" (error_position linebuf)

let process (optional_line : string option) =
  match optional_line with None -> () | Some line -> parse_and_print line

let rec repeat channel =
  (* Attempt to read one line. *)
  let optional_line, continue = Lexer.line channel in
  process optional_line;
  if continue then repeat channel

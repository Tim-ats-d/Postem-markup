open Lexing
open Printf

type t = string

let blue = Printf.sprintf "\027[0;34m%s\027[0m"

let red = Printf.sprintf "\027[0;31m%s\027[0m"

let orange = Printf.sprintf "\027[0;33m%s\027[0m"

let get_line filename line_nb =
  let ic = open_in filename in
  for _ = 1 to line_nb - 1 do
    ignore (input_line ic)
  done;
  input_line ic

let of_string ?hint ~msg =
  let err = red @@ Printf.sprintf "Error: %s." msg in
  match hint with
  | None -> err
  | Some h ->
      Printf.sprintf "%s\n%s" err @@ orange (Printf.sprintf "Hint: %s" h)

let of_position ?(cursor_length = 1) ?hint
    { pos_fname; pos_lnum; pos_cnum; pos_bol; _ } ~msg =
  let char_pos = pos_cnum - pos_bol in
  if pos_fname = "REPL" then
    Printf.sprintf "Error: %s.\n%s %i:%i" msg pos_fname pos_lnum char_pos
  else
    let padding = String.make (String.length @@ string_of_int pos_lnum) ' ' in
    let cline = get_line pos_fname pos_lnum
    and cursor = red @@ String.make cursor_length '^' in
    let overview =
      sprintf " %s%s\n%s %s %s\n%s %s %s%s\n%s %s" padding (blue "╷")
        (blue @@ string_of_int pos_lnum)
        (blue "│") cline padding (blue "│")
        (String.make (if char_pos = 0 then 0 else char_pos - 1) ' ')
        cursor padding (blue "╵")
    and carret = sprintf "%s %s %i:%i" padding pos_fname pos_lnum char_pos
    and hint =
      match hint with
      | None -> ""
      | Some h -> orange @@ Printf.sprintf "\nHint: %s." h
    in
    sprintf "%s\n%s\n%s%s"
      (red @@ Printf.sprintf "Error: %s." msg)
      overview carret hint

let of_lexbuf { lex_curr_p; _ } ~msg = of_position lex_curr_p ~msg

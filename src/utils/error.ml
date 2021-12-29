open Printf

type t = string

let blue = sprintf "\027[0;34m%s\027[0m"

let red = sprintf "\027[0;31m%s\027[0m"

let orange = sprintf "\027[0;33m%s\027[0m"

let get_line filename line_nb =
  let ic = open_in filename in
  for _ = 1 to line_nb - 1 do
    ignore (input_line ic)
  done;
  input_line ic

let rec of_string ?hint msg =
  let err = red @@ Printf.sprintf "Error: %s." msg in
  match hint with
  | None -> err
  | Some h -> sprintf "%s\n%s" err @@ hint_of_string h

and hint_of_string hint = orange @@ sprintf "Hint: %s" hint

let rec of_lexbuf { Lexing.lex_curr_p; _ } ~msg = of_position lex_curr_p ~msg

and of_position ?(cursor_length = 1) ?hint
    { Lexing.pos_fname; pos_lnum; pos_cnum; pos_bol; _ } ~msg =
  let pos_char = pos_cnum - pos_bol in
  if pos_fname = "REPL" then pp_repl msg pos_fname pos_lnum pos_char
  else
    let overview = pp_overview ~cursor_length pos_fname pos_lnum pos_char in
    let hint = Option.fold ~none:"" ~some:hint_of_string hint in
    sprintf "%s\n%s\n%s." (of_string msg) overview hint

and pp_repl msg filename line_num pos_char =
  let err = of_string msg in
  sprintf "%s\n%s %i:%i" err filename line_num pos_char

and pp_overview ~cursor_length filename line_num pos_char =
  let padding = String.make (String.length @@ Int.to_string line_num) ' ' in
  let cline = get_line filename line_num in
  let cursor = red @@ String.make cursor_length '^' in
  let overview =
    sprintf " %s%s\n%s %s %s\n%s %s %s%s\n%s %s" padding (blue "╷")
      (blue @@ Int.to_string line_num)
      (blue "│") cline padding (blue "│")
      (String.make (if pos_char = 0 then 0 else pos_char - 1) ' ')
      cursor padding
    @@ blue "╵"
  in
  let carret = sprintf "%s %s %i:%i" padding filename line_num pos_char in
  sprintf "%s\n%s " overview carret

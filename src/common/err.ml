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
  Option.fold ~none:err
    ~some:(fun h -> sprintf "%s\n%s" err @@ hint_of_string h)
    hint

and hint_of_string hint = orange @@ sprintf "Hint: %s" hint

let rec of_lexbuf lexbuf ~msg =
  let _, pos = Sedlexing.lexing_positions lexbuf in
  of_position pos ~msg

and of_position ?(cursor_length = 1) ?hint
    { Lexing.pos_fname; pos_lnum; pos_cnum; pos_bol; _ } ~msg =
  let pos_char = pos_cnum - pos_bol in
  match pos_fname with
  | "REPL" -> pp_repl msg hint pos_fname pos_lnum pos_char
  | "" -> pp_anon_file msg hint pos_lnum pos_char
  | _ ->
      let overview = pp_overview ~cursor_length pos_fname pos_lnum pos_char in
      let hint = Option.fold ~none:"" ~some:hint_of_string hint in
      sprintf "%s\n%s\n%s" (of_string msg) overview hint

and pp_repl msg hint filename line_num pos_char =
  let err = of_string msg in
  let hint = Option.fold ~none:"" ~some:hint_of_string hint in
  sprintf "%s\nFile \"%s\", line %i, character %i.\n%s" err filename line_num
    pos_char hint

and pp_anon_file msg hint line_num pos_char =
  let err = of_string msg in
  let hint = Option.fold ~none:"" ~some:hint_of_string hint in
  sprintf "%s\n  Line %i, character %i.\n%s" err line_num pos_char hint

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

let pp_string ?hint msg =
  let err = Printf.sprintf "Error: %s" msg in
  Option.fold ~none:err
    ~some:(fun h -> Printf.sprintf "%s\nHint: %s" err h)
    hint

let pp_position ?hint ~msg { Lexing.pos_fname; pos_lnum; pos_bol; pos_cnum }
    =
  let char_pos = pos_cnum - pos_bol in
  let carret =
    Printf.sprintf {|File "%s", line %i, characters %i:|} pos_fname pos_lnum
      char_pos
  in
  let descr =
    match hint with None -> pp_string msg | Some h -> pp_string msg ~hint:h
  in
  Printf.sprintf "%s\n%s" carret descr

let pp_lexbuf lexbuf ~msg =
  let spos, epos = Sedlexing.lexing_positions lexbuf in
  print_int epos.Lexing.pos_lnum;
  pp_position spos ~msg

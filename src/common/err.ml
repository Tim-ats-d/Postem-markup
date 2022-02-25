type loc = Lexing.position * Lexing.position
type checker_err = [ `UndefinedUop of loc ]
type expsn_err = [ `ExpsnAmbiguity of string | `UnknownExpsn of string ]
type parser_err = [ `IllegalCharacter of loc | `SyntaxError of loc ]
type t = [ checker_err | expsn_err | parser_err | `NoSuchFile of string ]

let get_line ic n =
  try
    let i = ref 1 in
    while !i < n do
      let _ = input_line ic in
      incr i
    done;
    input_line ic
  with End_of_file -> assert false

(* TODO: Fix Sys_error exception in REPL error. *)
let rec pp_loc ?hint ~msg (spos, epos) =
  let schar = Lexing.(spos.pos_cnum - spos.pos_bol) in
  let echar = Lexing.(epos.pos_cnum - epos.pos_bol) in
  let char_pos =
    if echar = 0 then Int.to_string schar
    else Printf.sprintf "%d-%d" schar echar
  in
  let carret =
    Printf.sprintf {|File "%s", line %i, characters %s:|} epos.Lexing.pos_fname
      spos.Lexing.pos_lnum char_pos
  in
  let overview =
    let line = get_line (open_in epos.Lexing.pos_fname) spos.Lexing.pos_lnum in
    let margin =
      String.make
        (schar + (spos.Lexing.pos_lnum |> string_of_int |> String.length))
        ' '
    in
    let cursor = if echar <= 0 then "^" else String.make (echar - schar) '^' in
    Printf.sprintf "%d | %s\n   %s%s" spos.Lexing.pos_lnum line margin cursor
  in
  let descr =
    match hint with None -> pp_string msg | Some hint -> pp_string msg ~hint
  in
  Printf.sprintf "%s\n%s\n%s" carret overview descr

and pp_string ?hint msg =
  let err = Printf.sprintf "Error: %s" msg in
  Option.fold ~none:err
    ~some:(fun h -> Printf.sprintf "%s\nHint: %s" err h)
    hint

let to_string = function
  | `UndefinedUop loc -> pp_loc loc ~msg:"Undefined op"
  | `ExpsnAmbiguity name ->
      pp_string
        ~hint:"Did you register your extension in src/expansion/known.ml?"
      @@ Printf.sprintf {|No extension found as "%s"|} name
  | `UnknownExpsn name ->
      pp_string
      @@ Printf.sprintf
           {|Ambiguity found: several extensions are known as "%s"|} name
  | `IllegalCharacter loc ->
      pp_loc loc ~msg:"Character not allowed in source text"
        ~hint:"try to escape this character"
  | `SyntaxError loc -> pp_loc loc ~msg:"Syntax error"
  | `NoSuchFile filename ->
      pp_string @@ Printf.sprintf "%s: no such file" filename

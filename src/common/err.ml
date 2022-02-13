type checker_err = [ `UndefinedUop of Lexing.position * Lexing.position ]
type expsn_err = [ `ExpsnAmbiguity of string | `UnknownExpsn of string ]

type parser_err =
  [ `IllegalCharacter of Sedlexing.lexbuf | `SyntaxError of Sedlexing.lexbuf ]

type t = [ checker_err | expsn_err | parser_err | `NoSuchFile of string ]

let rec pp_lexbuf ?hint ~msg lexbuf =
  let spos, _ = Sedlexing.lexing_positions lexbuf in
  pp_position spos ~msg ~hint

and pp_position ~hint ~msg { Lexing.pos_fname; pos_lnum; pos_bol; pos_cnum } =
  let char_pos = pos_cnum - pos_bol in
  let carret =
    Printf.sprintf {|File "%s", line %i, characters %i:|} pos_fname pos_lnum
      char_pos
  in
  let descr =
    match hint with None -> pp_string msg | Some hint -> pp_string msg ~hint
  in
  Printf.sprintf "%s\n%s" carret descr

and pp_string ?hint msg =
  let err = Printf.sprintf "Error: %s" msg in
  Option.fold ~none:err
    ~some:(fun h -> Printf.sprintf "%s\nHint: %s" err h)
    hint

(* TODO: Better error message. *)
let to_string = function
  | `UndefinedUop (spos, _epos) ->
      pp_position spos ~msg:"Undefined op" ~hint:None
  | `ExpsnAmbiguity name ->
      pp_string
        ~hint:"Did you register your extension in src/expansion/known.ml?"
      @@ Printf.sprintf {|no extension found as "%s"|} name
  | `UnknownExpsn name ->
      pp_string
      @@ Printf.sprintf
           {|ambiguity found: several extensions are known as "%s"|} name
  | `IllegalCharacter lexbuf -> pp_lexbuf lexbuf ~msg:"syntax error"
  | `SyntaxError lexbuf ->
      pp_lexbuf lexbuf ~msg:"character not allowed in source text"
        ~hint:"try to escape this character."
  | `NoSuchFile filename ->
      pp_string @@ Printf.sprintf "%s: no such file" filename

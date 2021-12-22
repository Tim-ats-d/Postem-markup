open Utils
module Sedlex = Sedlexing.Utf8


let from_lexbuf lexbuf (module Expsn : Expansion.Type.S) =
  match Parsing.parse_document lexbuf with
  | Ok ast -> (
      let module Eval = Ast.Eval.MakeWithExpsn (Expsn) in
      try Ok (Eval.eval ast)
      with Ast.Eval.Missing_metamark ({ startpos; endpos }, name) ->
        let msg = Printf.sprintf "missing metamark '%s'" name
        and hint =
          "try to define your metamark in the used expansion and reinstall \
           Postem"
        and cursor_length = endpos.pos_cnum - endpos.pos_bol in
        Error (Error.of_position startpos ~msg ~hint ~cursor_length))
  | Error _ as err -> err

let from_str str (module Expsn : Expansion.Type.S) =
  let lexbuf = Sedlex.from_string str in
  Sedlexing.set_filename lexbuf "REPL";
  from_lexbuf lexbuf (module Expsn)

let from_file filename (module Expsn : Expansion.Type.S) =
  let lexbuf = Sedlex.from_channel (open_in filename) in
  Sedlexing.set_filename lexbuf filename;
  from_lexbuf lexbuf (module Expsn)

let compile () =
  let args =
    Args.parse ~on_empty:(fun args ->
        Repl.launch (fun input ->
            from_str input (Expsn_handler.load args.expansion)))
  in
  let module Expansion = (val Expsn_handler.load args.expansion) in
  match from_file args.input_file (module Expansion) with
  | Ok r ->
      if args.output_on_stdout then print_endline r
      else File.write args.output_file r
  | Error msg ->
      prerr_endline msg;
      exit 1

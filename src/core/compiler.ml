open Utils

let from_str ~filename (module Expsn : Expansion.Type.S) str =
  let lexbuf = Lexing.from_string str in
  match Parsing.parse_document lexbuf with
  | Ok ast -> (
      Ast.Eval.(
        try Ok (eval (module Expsn) filename ast)
        with Missing_meta _ -> Error "missing meta mark"))
  | Error _ as err -> err

let from_file (module Expsn : Expansion.Type.S) filename =
  File.read_all filename |> from_str (module Expsn) ~filename

let compile () =
  let args =
    Args.parse ~on_empty:(fun args ->
        Repl.launch
          (from_str ~filename:"REPL" (Expsn_handler.load args.expansion)))
  in
  let module Expansion = (val Expsn_handler.load args.expansion) in
  match from_file (module Expansion) args.input_file with
  | Ok r ->
      if args.output_on_stdout then print_endline r
      else File.write args.output_file r
  | Error msg ->
      prerr_endline msg;
      exit 1

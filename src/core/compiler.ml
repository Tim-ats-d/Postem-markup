open Parsing
open Utils

let from_str ?(filename = "") (module Expsn : Expansion.Type.S) str =
  let lexbuf = Lexing.from_string str in
  match Lex_and_parse.parse_document lexbuf with
  | Ok ast -> Ast.Eval.eval (module Expsn) filename ast |> Result.ok
  | Error _ as err -> err

let from_file (module Expsn : Expansion.Type.S) filename =
  File.read_all filename |> from_str (module Expsn) ~filename

let launch_repl (module Expsn : Expansion.Type.S) =
  let input = ref [] in
  try
    while true do
      input := read_line () :: !input
    done
  with End_of_file -> (
    print_newline ();
    match String.concat "\n" !input |> from_str (module Expsn) with
    | Ok output ->
        print_endline output;
        exit 0
    | Error msg ->
        prerr_endline msg;
        exit 1)

let compile () =
  let args =
    Args.parse ~on_empty:(fun args ->
        launch_repl (Loader.load_expansion args.expansion))
  in
  let module Expansion = (val Loader.load_expansion args.expansion) in
  match from_file (module Expansion) args.input_file with
  | Ok r ->
      if args.output_on_stdout then print_endline r
      else File.write args.output_file r
  | Error msg -> prerr_endline msg

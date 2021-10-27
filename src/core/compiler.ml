open Parsing
open Utils

let load_expansion expsn_name =
  let found_expsn =
    List.filter
      (fun (name, _) -> if name = expsn_name then true else false)
      Expansion.Known.expansions
  in
  match found_expsn with
  | [] ->
      Printf.eprintf
        {|Error: no extension found as "%s". Did you register your extension in src/expansion/known.ml ?|}
        expsn_name;
      exit 1
  | [ (_, expsn) ] -> expsn
  | _ ->
      Printf.eprintf
        {|Error: ambiguity found. Several extensions are known as "%s"|}
        expsn_name;
      exit 1

let from_str ?(filename = "") (module Expsn : Expansion.Type.S) str =
  let lexbuf = Lexing.from_string str in
  match Lex_and_parse.parse_document lexbuf with
  | Ok ast -> Ast.Eval.eval (module Expsn) filename ast |> Result.ok
  | Error _ as err -> err

let from_file filename (module Expsn : Expansion.Type.S) =
  File.read_all filename |> from_str (module Expsn) ~filename

let compile () =
  let args = Args.parse () in
  let module Expansion = (val load_expansion args.expansion) in
  match from_file args.input_file (module Expansion) with
  | Ok r ->
      if args.output_on_stdout then print_endline r
      else File.write args.output_file r
  | Error msg -> prerr_endline msg

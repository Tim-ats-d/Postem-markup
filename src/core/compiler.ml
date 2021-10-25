open Parsing
open Utils

let from_file filename (module Ext : Ext.Expansion.S) =
  let lexbuf = File.read_all filename |> Lexing.from_string in
  match Lex_and_parse.parse_document lexbuf with
  | Ok ast -> Ast.Eval.eval (module Ext) filename ast |> Result.ok
  | Error _ as err -> err

let compile () =
  let args = Args.parse () in
  match from_file args.input_file (module Ext.Expansion.Default) with
  | Ok r ->
      if args.output_on_stdout then print_endline r
      else File.write args.output_file r
  | Error msg -> prerr_endline msg

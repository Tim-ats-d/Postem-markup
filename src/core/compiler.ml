open Parsing
open Utils


let from_string (module Ext : Ext.Expansion.S) str =
  let lexbuf = Lexing.from_string str in
  match Lex_and_parse.parse_document lexbuf with
  | Ok ast -> Lex_and_parse.pprint_parsed_ast ast |> Result.ok
  | Error _ as e -> e


let from_file filename (module Ext : Ext.Expansion.S) =
  File.read_all filename |> from_string (module Ext)

let compile () =
  let args = Args.parse () in
  match from_file args.input_file (module Ext.Expansion.Default) with
  | Ok r ->
      if args.output_on_stdout then print_endline r
      else File.write args.output_file r
  | Error e -> prerr_endline e

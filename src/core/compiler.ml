open Parsing
open Utils

let compile filename (module Ext : Ext.Expansion.S) =
  let document = File.read_all filename in
  match Parser.parse document with
  | Ok ast -> Ast.(Eval.eval filename ast ~ext:(module Ext)) |> print_endline
  | Error err -> prerr_endline err

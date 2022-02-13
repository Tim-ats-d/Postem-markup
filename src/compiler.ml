open Common
open Core

let load_unit name =
  match Ehandler.load Expansion.Known.expansions name with
  | Ok expsn -> expsn
  | Error err -> prerr_with_exit @@ Err.to_string (err :> Err.t)

let compile () =
  let args = Args.parse () in
  let module Expsn = (val load_unit args#expsn) in
  let module Eval = struct
    type t = string

    include Ast.Eval.MakeWithExpsn (Expsn)
  end in
  let module Compiler =
    Compil_impl.Make (Syntax.Parser) (Checker.Make (Expsn)) (Eval)
  in
  if args#direct_input = "" && args#inputf = "" then
    let module Repl = Repl.Make (Compiler) in
    Repl.launch ()
  else
    let from_src =
      if args#direct_input = "" then
        if Sys.file_exists args#inputf then
          Compiler.from_channel ~filename:args#inputf @@ open_in args#inputf
        else prerr_with_exit @@ Err.to_string (`NoSuchFile args#inputf)
      else Compiler.from_string ~filename:args#inputf args#inputf
    in
    match from_src with
    | Ok r ->
        if args#output_on_stdout then print_endline r
        else In_channel.write args#outputf r
    | Error err -> prerr_with_exit @@ Err.to_string err

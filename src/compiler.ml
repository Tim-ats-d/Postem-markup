open Common
open Core

let prerr_with_exit err =
  prerr_endline err;
  exit 1

module Repl = struct
  let launch eval =
    let input = ref [] in
    try
      while true do
        input := read_line () :: !input
      done
    with End_of_file -> (
      print_newline ();
      match List.rev !input |> String.concat "\n" |> eval with
      | Ok output ->
          print_endline output;
          exit 0
      | Error err -> prerr_with_exit @@ Err.to_string err)
end

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
    Repl.launch @@ Compiler.from_string ~filename:"REPL"
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

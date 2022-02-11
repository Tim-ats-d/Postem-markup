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
      | Error msg -> prerr_with_exit msg)
end

let load_unit name =
  match Ehandler.load_res Expansion.Known.expansions name with
  | Ok expsn -> expsn
  | Error (msg, hint) -> prerr_with_exit @@ Err.pp_string msg ~hint

module Parser = struct
  let parse lexbuf =
    let open Syntax in
    let lexer = Sedlexing.with_tokenizer Lexer.read_debug lexbuf in
    let parser =
      MenhirLib.Convert.Simplified.traditional2revised Parser.document
    in
    try Result.ok @@ parser lexer with
    | Lexer.Syntax_error lexbuf ->
        let _, pos = Sedlexing.lexing_positions lexbuf in
        Result.error
        @@ Err.pp_position pos ~msg:"character not allowed in source text"
             ~hint:"try to escape this character."
    | Parser.Error -> Result.error @@ Err.pp_lexbuf lexbuf ~msg:"syntax error"
end

let compile () =
  let args = Args.parse () in
  let module Expsn = (val load_unit args#expsn) in
  let module Eval = struct
    type t = string

    include Ast.Eval_expsn.MakeWithExpsn (Expsn)
  end in
  let module Compiler = Compil_impl.Make (Parser) (Eval) in
  if args#direct_input = "" && args#inputf = "" then
    Repl.launch @@ Compiler.from_string ~filename:"REPL"
  else
    let from_src =
      if args#direct_input = "" then
        if Sys.file_exists args#inputf then
          Compiler.from_channel ~filename:args#inputf @@ open_in args#inputf
        else
          prerr_with_exit
          @@ Printf.sprintf "Error: \"%s\": no such file" args#inputf
      else Compiler.from_string ~filename:args#inputf args#inputf
    in
    match from_src with
    | Ok r ->
        if args#output_on_stdout then print_endline r
        else File.write args#outputf r
    | Error msg -> prerr_with_exit msg

open Utils

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
      | Error msg ->
          prerr_endline msg;
          exit 1)
end

let compile () =
  let load_unit name =
    match Ehandler.load_res Expansion.Known.expansions name with
    | Ok expsn -> expsn
    | Error (msg, hint) ->
        prerr_endline @@ Error.of_string msg ~hint;
        exit 1
  in
  let args = Args.parse () in
  let module Expsn = (val load_unit args#expansion) in
  let module Compiler = Compil_impl.Make (struct
    type t = string

    include Ast.Eval.MakeWithExpsn (Expsn)
  end) in
  if args#direct_input = "" && args#input_file = "" then
    Repl.launch @@ Compiler.from_string ~filename:"REPL"
  else
    let from_src =
      if args#direct_input = "" then
        Compiler.from_channel ~filename:args#input_file
        @@ open_in args#input_file
      else Compiler.from_string ~filename:args#input_file args#direct_input
    in
    match from_src with
    | Ok r ->
        if args#output_on_stdout then print_endline r
        else File.write args#output_file r
    | Error msg ->
        prerr_endline msg;
        exit 1

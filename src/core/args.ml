open Utils

type t = {
  mutable input_file : string;
  mutable output_file : string;
  mutable expansion : string;
  mutable output_on_stdout : bool;
}

let default =
  {
    input_file = "";
    output_file = "";
    expansion = "default";
    output_on_stdout = true;
  }

let usage_msg = "postem [-o output] [-e expansion] <file>"

let speclist =
  let open Arg in
  [
    ( "-e",
      String (fun e -> default.expansion <- e),
      "Set the expansion used to render input" );
    ( "-l",
      Unit
        (fun () ->
          Expsn_handler.print ();
          exit 0),
      "Display the list of known expansions and exit." );
    ( "-o",
      String
        (fun f ->
          default.output_on_stdout <- false;
          default.output_file <- f),
      "Set output file name" );
    ( "--version",
      Unit
        (fun () ->
          print_endline "%%VERSION%%";
          exit 0),
      "Display the version number and exit" );
  ]

let parse ~on_empty =
  Arg.parse speclist (fun i -> default.input_file <- i) usage_msg;
  if String.is_empty default.input_file then on_empty default;
  default

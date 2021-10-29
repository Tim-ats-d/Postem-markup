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
    output_on_stdout = false;
  }

let usage_msg = "postem [-s | -e expansion] <file> -o <output>"

let version = "0.0.1"

let speclist =
  let open Arg in
  [
    ("-o", String (fun f -> default.output_file <- f), "Set output file name");
    ( "-s",
      Unit (fun () -> default.output_on_stdout <- true),
      "Output result on stdout" );
    ( "-e",
      String (fun e -> default.expansion <- e),
      "Set the expansion used to render input" );
    ( "--version",
      Unit
        (fun () ->
          print_endline version;
          exit 0),
      "Display the version number and exit" );
  ]

let parse ~on_empty =
  Arg.parse speclist (fun i -> default.input_file <- i) usage_msg;
  if String.is_empty default.input_file then on_empty default;
  default

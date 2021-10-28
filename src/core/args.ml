open Utils

type t = {
  input_file : string;
  output_file : string;
  expansion : string;
  output_on_stdout : bool;
}

let create ~input_file ~output_file ~expansion ~output_on_stdout =
  { input_file; output_file; expansion; output_on_stdout }

let usage_msg = "postem [-s | -e expansion] file -o <output>"

let output_on_stdout = ref false

let input_file = ref ""

let output_file = ref ""

let expansion = ref "default"

let speclist =
  let open Arg in
  [
    ("-o", Set_string output_file, "Set output file name");
    ("-s", Set output_on_stdout, "Output result on stdout");
    ("-e", Set_string expansion, "Path of expansion used to render input");
  ]

let parse () =
  Arg.parse speclist (( := ) input_file) usage_msg;
  if String.is_empty !input_file then (
    Arg.usage speclist usage_msg;
    exit 1);
  create ~input_file:!input_file ~output_file:!output_file ~expansion:!expansion
    ~output_on_stdout:!output_on_stdout

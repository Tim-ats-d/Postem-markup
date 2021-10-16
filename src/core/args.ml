type t = { input_file : string; output_file : string; expansion_path : string; output_on_stdout : bool }

let create ~input_file ~output_file ~expansion_path ~output_on_stdout =
  { input_file; output_file; expansion_path; output_on_stdout }

let usage_msg = "postem [-s] file -o <output>"

let output_on_stdout = ref false

let input_file = ref ""

let output_file = ref ""

let expansion_path = ref ""

let speclist =
  let open Arg in
  [
    ("-o", Set_string output_file, "Set output file name");
    ("-s", Set output_on_stdout, "Output result on stdout");
    ("-e", Set_string expansion_path, "Path of expansion used to render input")
  ]

let parse () =
  Arg.parse speclist (( := ) input_file) usage_msg;
  create ~input_file:!input_file ~output_file:!output_file
    ~expansion_path:!expansion_path
    ~output_on_stdout:!output_on_stdout

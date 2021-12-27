open Utils

type t =
  < input_file : string
  ; output_file : string
  ; expansion : string
  ; output_on_stdout : bool >

class args =
  object
    val mutable input_file = ""

    val mutable output_file = ""

    val mutable expansion = "default"

    val mutable output_on_stdout = true

    method input_file = input_file

    method output_file = output_file

    method expansion = expansion

    method output_on_stdout = output_on_stdout

    method set_input_file f = input_file <- f

    method set_output_file f = output_file <- f

    method set_expansion e = expansion <- e

    method set_output_on_stdout b = output_on_stdout <- b
  end

class arg_parser ~usage_msg =
  object
    val args = new args

    method args = args

    val mutable speclist = []

    method add_spec short long spec descr =
      let sshort = ("-" ^ short, spec, descr) in
      let slong = ("--" ^ long, spec, descr) in
      speclist <- slong :: sshort :: speclist

    method parse ~on_empty =
      Arg.parse speclist args#set_input_file usage_msg;
      if String.is_empty args#input_file then on_empty args;
      (args :> t)
  end

let parse ~on_empty =
  let p =
    new arg_parser ~usage_msg:"postem [-o output] [-e expansion] <file>"
  in
  let open Arg in
  p#add_spec "e" "expansion" (String p#args#set_expansion)
    "Set the expansion used to render input";
  p#add_spec "l" "list"
    (Unit
       (fun () ->
         Expsn_handler.print ();
         exit 0))
    "Display the list of known expansions and exit.";
  p#add_spec "o" "output"
    (String
       (fun f ->
         p#args#set_output_on_stdout false;
         p#args#set_output_file f))
    "Set output file name";
  p#add_spec "v" "version"
    (Unit
       (fun () ->
         print_endline "%%VERSION%%";
         exit 0))
    "Display the version number and exit";
  p#parse ~on_empty

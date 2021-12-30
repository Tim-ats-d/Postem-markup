type t =
  < direct_input : string
  ; input_file : string
  ; output_file : string
  ; expansion : string
  ; output_on_stdout : bool >

class args =
  object
    val mutable direct_input = ""

    val mutable input_file = ""

    val mutable output_file = ""

    val mutable expansion = "default"

    val mutable output_on_stdout = true

    method direct_input = direct_input

    method input_file = input_file

    method output_file = output_file

    method expansion = expansion

    method output_on_stdout = output_on_stdout

    method set_direct_input i = direct_input <- i

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

    method add_spec ?long short spec descr =
      let sshort = ("-" ^ short, spec, descr) in
      match long with
      | None -> speclist <- sshort :: speclist
      | Some l ->
          let slong = ("--" ^ l, spec, descr) in
          speclist <- slong :: sshort :: speclist

    method parse =
      Arg.parse speclist (fun _ -> ()) usage_msg;
      (args :> t)
  end

let parse () =
  let p = new arg_parser ~usage_msg:"postem [OPTIONS]..." in
  (let open Arg in
  p#add_spec "c" (String p#args#set_direct_input)
    "Postem string to parse directly";
  p#add_spec "e" ~long:"expansion" (String p#args#set_expansion)
    "Set the expansion used to render input";
  p#add_spec "i" (String p#args#set_input_file))
    "Name of the file to be evaluated.";
  p#add_spec "l" ~long:"list"
    (Unit
       (fun () ->
         print_endline @@ Ehandler.to_string Expansion.Known.expansions;
         exit 0))
    "Display the list of known expansions and exit.";
  p#add_spec "o" ~long:"output"
    (String
       (fun f ->
         p#args#set_output_on_stdout false;
         p#args#set_output_file f))
    "Set output file name";
  p#add_spec "v" ~long:"version"
    (Unit
       (fun () ->
         print_endline "%%VERSION%%";
         exit 0))
    "Display the version number and exit";
  p#parse

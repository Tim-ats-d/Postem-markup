type t = {
  input_file : string;
  output_file : string;
  expansion_path : string;
  output_on_stdout : bool;
}

val parse : unit -> t

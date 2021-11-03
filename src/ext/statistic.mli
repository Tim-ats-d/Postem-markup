type t = private {
  filename : string;
  content : string;
  lines_nb : int;
  max_line_length : int;
}

val from_file : Utils.File.t -> string -> t

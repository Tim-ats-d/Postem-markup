type t = private { filename : string; content : string; lines_nb : int; max_line_length : int}

val create : Utils.File.t -> string -> t
 
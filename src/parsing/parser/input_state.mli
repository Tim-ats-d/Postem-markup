type t = { lines : string array; position : Position.t }

val of_str : string -> t

val current_line : t -> string

val next_char : t -> t * char option

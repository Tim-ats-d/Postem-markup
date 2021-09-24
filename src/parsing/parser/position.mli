type t = { current_line : string; line : int; column : int }

val initial : unit -> t

val incr_col : t -> t

val incr_line : t -> t

type t

val empty : t

val create : unit -> t

val add : t -> string -> string -> unit

val substitute : t -> string -> string

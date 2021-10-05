type t = string Map.Make(Utils.String).t

val empty : t

val add : t -> string -> string -> t

val substitute : t -> string -> string

val merge : t -> t -> t

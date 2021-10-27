type t = string Map.Make(Utils.String).t
(** The type representing a key value association. *)

val empty : t
(** An empty context. *)

val add : t -> string -> string -> t
(** [add ctx name value] returns a new context object where [name] is associated to [value]. *)

val substitute : t -> string -> string
(** [subsitute ctx name] returns the value associated to [name] if the key [name] is present in [ctx], [name] otherwise. *)

val merge : t -> t -> t
(** [merge ctx ctx'] returns a new context object made up of the merger of [ctx] and [ctx']. *)

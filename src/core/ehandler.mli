(** Utilities to load expansion.

Expansions must be placed in [src/expansion/] folder and be registered in
[src/expansion/known.ml]. *)

(** {1 API} *)

module KnownExpansions : sig
  type t = (name * doc * (module Ast.Expansion.S)) list
  and name = string
  and doc = string

  val to_string : t -> string
  (** Prettify given known expansions and returns it as a string. *)
end

val load :
  KnownExpansions.t ->
  KnownExpansions.name ->
  ((module Ast.Expansion.S), Common.Err.expsn_err) result
(** [load_res known_expsn name] returns [Ok e] where [e] is expansions module
associated to [name], [Error err] otherwise. *)

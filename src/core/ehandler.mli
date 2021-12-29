(** Utilities to load expansion.

Expansions must be placed in the [src/expansion] folder and be registered in
the [src/expansion/known.ml]. *)

(** {1 API} *)

module KnownExpansions : sig
  type t = (name * doc * (module Ast.Expansion.S)) list

  and name = string

  and doc = string
end

exception UnknownExpsn of string * string

exception ExpsnAmbiguity of string * string

val load_exn :
  KnownExpansions.t -> KnownExpansions.name -> (module Ast.Expansion.S)
(** [load_exn known_expsn name] returns expansions module associated with
the name [name].

@raise UnknownExpsn If any expansion does not match [name].
@raise ExpsnAmbiguity If several expansions match [name]. *)

val load_res :
  KnownExpansions.t ->
  KnownExpansions.name ->
  ((module Ast.Expansion.S), string * string) result
(** [load_res known_expsn name] returns [Ok e] where e is expansions module
associated with the name [name] and [Error (msg, hint)] if an error is
encountered. *)

val to_string : KnownExpansions.t -> string
(** Prettify given known expansions and returns it as a string. *)

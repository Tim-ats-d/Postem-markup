val load : string -> (module Ast.Expansion.S)
(** [load expansion_name] returns expansions module associated with
the name [expansion_name] of the [Expansion.Known.expansions].

If any expansion or several are registered under [expansion_name], prints an
error message and exit. *)

val print : unit -> unit
(** Display the list of [Expansion.Known.expansions] on standard output. *)

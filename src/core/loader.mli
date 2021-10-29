val load_expansion : string -> (module Expansion.Type.S)
(** [load_expansion expansion_name] returns expansions module associated with
the name [expansion_name] of the [Expansion.Known.expansions].

If any expansion or several are registered under [expansion_name], prints an
error message and exit. *)

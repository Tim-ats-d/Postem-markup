exception Missing_metamark of Ast_types.loc * string
(** Exception raised by [eval] function when a meta tag is mentionned in postem code and it doesn't exist. *)

val eval : (module Expansion.Type.S) -> Ast_types.document -> string
(** [eval expansion document] returns the string corresponding to the evaluation of [document].
  The module [expansion] is used to generate the compilation rendering.

  @raise Missing_metamark
*)

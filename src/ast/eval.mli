exception Missing_file of Lexing.position * string
(** Exception raised by [eval] function when a file mentionned in include doesn't exist. *)

val eval :
  (module Expansion.Type.S) -> Utils.File.t -> Ast_types.document -> string
(** [eval ext filename document] returns the string corresponding to the evaluation of [document].
  The module [ext] is used to generate the compilation rendering.

  @raise Missing_file
*)

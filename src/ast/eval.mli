val eval :
  (module Expansion.Type.S) -> Utils.File.t -> Ast_types.document -> string
(** [eval ext filename document] returns the string corresponding to the evaluation of [document].
  The module [ext] is used to generate the compilation rendering. *)

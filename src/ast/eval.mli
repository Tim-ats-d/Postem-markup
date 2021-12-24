exception Missing_metamark of Ast_types.loc * string
(** Exception raised by [eval] function when a meta tag is mentionned in postem code and it doesn't exist. *)

module type S = sig
  (** A functor which takes an expansion in parameter and returns a complete evaluator. *)

  val eval : Ast_types.expr list -> string
  (** [eval doc] returns the string corresponding to the evaluation of [doc].

  @raise Missing_metamark *)
end

module MakeWithExpsn : functor (Expsn : Expansion.S) -> S

(** {1 API} *)

exception Missing_metamark of Ast_types.loc * string
(** Exception raised by [eval] function when a meta tag is mentionned in postem code and it doesn't exist. *)

(** Output signature of the functor [Eval_expsn.MakeWithExpsn]. *)
module type S = sig
  val eval : Ast_types.expr Ast_types.document -> string
  (** [eval doc] returns the string corresponding to the evaluation of [doc].

  @raise Missing_metamark *)
end

(** Functor building a string evaluator from an expansion. *)
module MakeWithExpsn : functor (Expsn : Expansion.S) -> S

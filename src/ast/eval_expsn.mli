(** {1 API} *)

(** Output signature of the functor [Eval_expsn.MakeWithExpsn]. *)
module type S = sig
  val eval : Ast_types.doc -> (string, string) result
  (** [eval doc] returns [Ok r] if evaluation goes well and [Error msg]
    otherwise. *)
end

(** Functor building a string evaluator from an expansion. *)
module MakeWithExpsn : functor (Expsn : Expansion.S) -> S

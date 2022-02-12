(** {1 API} *)

(** Output signature of the functor [Eval_expsn.MakeWithExpsn]. *)
module type S = sig
  val eval : Types.doc -> string
end

(** Functor building a string evaluator from an expansion. *)
module MakeWithExpsn : functor (Expsn : Expansion.S) -> S

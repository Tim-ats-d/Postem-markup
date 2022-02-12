(** {1 API} *)

(** Output signature of the functor [Eval_expsn.MakeWithExpsn]. *)
module type S = sig
  type t

  val eval : Types.doc -> t
end

(** Functor building a string evaluator from an expansion. *)
module MakeWithExpsn : functor (Expsn : Expansion.S) -> S with type t := string

(** {1 API} *)

(** Input signature of the functor [Eval_impl.Make]. *)
module type WRITER = sig
  type t
  (** The written type. *)

  val eval : Preprocess.metadata -> Ast_types.value Ast_types.document -> t list
end

(** Output signature of the functor [Eval_impl.Make]. *)
module type CUSTOM_WRITER = sig
  type t

  val eval : ?alias:Context.t -> Ast_types.expr Ast_types.document -> t list
end

(** Functor building an implementation of an evaluator writing its type [t]. *)
module Make : functor (Writer : WRITER) -> CUSTOM_WRITER with type t := Writer.t

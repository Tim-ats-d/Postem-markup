(** {1 API} *)

(** Input signature of the functor [Eval_impl.Make]. *)
module type WRITER = sig
  type t
  (** The written type. *)

  val eval :
    alias:Ctx.StringCtx.t ->
    uop:Ctx.UopCtx.t ->
    Ast_types.doc ->
    (t, string) result
end

(** Output signature of the functor [Eval_impl.Make]. *)
module type CUSTOM_WRITER = sig
  type t

  val eval :
    alias:Ctx.StringCtx.t ->
    uop:Ctx.UopCtx.t ->
    Ast_types.doc ->
    (t, string) result
end

(** Functor building an implementation of an evaluator writing its type [t]. *)
module Make : functor (Writer : WRITER) -> CUSTOM_WRITER with type t := Writer.t

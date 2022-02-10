(** {1 API} *)

val pp_doc : Ctx.StringCtx.t -> Ast_types.doc -> Ctx.StringCtx.t * Ast_types.doc
(** [ppdoc ctx edoc] returns a tuple composed of a context object containing
  alias def collected on [edoc] and a [expr document] where parsed expression
  have been eliminated. *)

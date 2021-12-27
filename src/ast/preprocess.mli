(** {1 Type} *)

type metadata = { headers : (Share.TitleLevel.t * Ast_types.expr list) list }
(** Type containing information collected during preprocessing of the document. *)

(** {2 API} *)

val ppdoc :
  Context.t ->
  Ast_types.expr Ast_types.document ->
  metadata * Ast_types.value Ast_types.document
(** [ppdoc ctx edoc] returns a couple composed of metadata collected on [edoc]
  and a [value document] where expression have been eliminated. *)

(** {1 Type} *)

type metadata = { headers : (Share.TitleLevel.t * Ast_types.expr list) list }
(** Type containing information collected during preprocessing of the document. *)

(** {2 API} *)

val pp_doc : Context.t -> Ast_types.doc -> metadata * Ast_types.doc
(** [ppdoc ctx edoc] returns a couple composed of metadata collected on [edoc]
  and a [expr document] where parsed expression have been eliminated. *)

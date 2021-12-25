type metadata = { headers : (Share.TitleLevel.t * Ast_types.expr list) list }

val ppdoc :
  Context.t ->
  Ast_types.expr Ast_types.element list ->
  metadata * Ast_types.atom Ast_types.element list

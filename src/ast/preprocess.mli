type metadata = { headers : (int * Ast_types.expr) list }

val preprocess :
  Context.t -> Ast_types.document -> metadata * Ast_types.expr list
(** [preprocess ctx doc] returns an expression list representing [doc] preprocessed with [ctx] as initial context.

The preprocessing consists of replace each alias by its value. *)

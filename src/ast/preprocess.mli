val preprocess : Env.t -> Ast_types.document -> Ast_types.expr list
(** [preprocess env doc] returns an expression list representing [doc] preprocessed with [env] as initial execution environment.

The preprocessing consists of replace each alias by its value and gleaning data from the document. *)

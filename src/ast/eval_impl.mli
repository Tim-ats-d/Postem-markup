module type WRITER = sig
  type t
  (** The written type. *)

  val eval : Preprocess.metadata -> Ast_types.atom Ast_types.document -> t list
end

module type CUSTOM_WRITER = sig
  type t

  val eval : ?alias:Context.t -> Ast_types.expr Ast_types.document -> t list
end

module Make : functor (Writer : WRITER) -> sig
  val eval :
    ?alias:Context.t -> Ast_types.expr Ast_types.document -> Writer.t list
end

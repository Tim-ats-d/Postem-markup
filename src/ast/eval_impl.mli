module type S = sig
  type t
  (** The written type. *)

  val eval : Preprocess.metadata -> Ast_types.expr list -> t list
end

module type CUSTOM_WRITER = sig
  type t

  val eval : ?alias:Context.t -> Ast_types.expr list -> t list
end

module Make (Writer : S) : CUSTOM_WRITER with type t := Writer.t

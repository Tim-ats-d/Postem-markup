module type WRITER = sig
  type t

  val eval : Preprocess.metadata -> Ast_types.expr list -> t list
end

module type CUSTOM_WRITER = sig
  type t

  val eval : ?alias:Context.t -> Ast_types.expr list -> t list
end

module Make (Writer : WRITER) : CUSTOM_WRITER with type t := Writer.t = struct
  let eval ?(alias = Context.empty) doc =
    let metadata, elist = Preprocess.preprocess alias doc in
    Writer.eval metadata elist
end

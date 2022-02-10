open Ast_types

module type WRITER = sig
  type t

  val eval : Ctx.StringCtx.t -> doc -> (t, string) result
end

module type CUSTOM_WRITER = sig
  type t

  val eval : ?alias:Ctx.StringCtx.t -> doc -> (t, string) result
end

module Make (Writer : WRITER) : CUSTOM_WRITER with type t := Writer.t = struct
  let eval ?(alias = Ctx.StringCtx.empty) doc =
    let metadata, elist = Preprocess.pp_doc alias doc in
    Writer.eval metadata elist
end

open Ast_types

module type WRITER = sig
  type t

  val eval :
    alias:Ctx.StringCtx.t ->
    uop:Ctx.UopCtx.t ->
    Ast_types.doc ->
    (t, string) result
end

module type CUSTOM_WRITER = sig
  type t

  val eval :
    alias:Ctx.StringCtx.t -> uop:Ctx.UopCtx.t -> doc -> (t, string) result
end

module Make (Writer : WRITER) : CUSTOM_WRITER with type t := Writer.t = struct
  let eval ~alias ~uop doc =
    let alias', elist = Preprocess.pp_doc alias doc in
    Writer.eval elist ~alias:alias' ~uop
end

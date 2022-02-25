module type S = sig
  val alias : Common.Ctx.AliasCtx.t
  val bop : Common.Ctx.BinOpCtx.t
  val uop : Common.Ctx.UopCtx.t
end

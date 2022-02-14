open Common

module type S = sig
  type t

  val eval : Types.doc -> t
end

module EvalCtx = struct
  type t = { alias : Ctx.AliasCtx.t; uop : Ctx.UopCtx.t }

  let create ~alias ~uop = { alias; uop }
end

module MakeWithExpsn (Expsn : Expansion.S) : S with type t := string = struct
  let rec eval doc =
    let ctx = Expsn.(EvalCtx.create ~alias ~uop) in
    List.map (eval_expr ctx) doc |> String.concat ""

  and eval_expr ctx expr =
    let open Types in
    match expr with
    | Text s | White s -> s
    | Group grp -> eval_group ctx grp
    | UnaryOp { op; group } -> eval_uop ctx op group

  and eval_group ctx grp = List.map (eval_expr ctx) grp |> String.concat ""

  and eval_uop ctx op group =
    let f = Ctx.UopCtx.find ctx.EvalCtx.uop op in
    f @@ eval_expr ctx group
end

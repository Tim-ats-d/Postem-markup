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
    let buf = eval_doc doc ~alias:Expsn.alias ~uop:Expsn.uop in
    Buffer.contents buf

  and eval_doc ~alias ~uop doc =
    let buf = Buffer.create 101 in
    (* TODO: performance issue *)
    let ctx = EvalCtx.create ~alias ~uop in
    List.iter
      (fun expr ->
        let text = eval_expr ctx expr in
        Buffer.add_string buf text)
      doc;
    buf

  and eval_expr ctx expr =
    let open Types in
    match expr with
    | Text s | White s -> s
    | Group grp -> eval_group ctx grp
    | UnaryOp { op; group } -> eval_uop ctx op group

  and eval_group ctx grp = String.concat "" @@ List.map (eval_expr ctx) grp

  and eval_uop ctx op group =
    let f = Ctx.UopCtx.find ctx.EvalCtx.uop op in
    f @@ eval_expr ctx group
end

module type S = sig
  val eval : Ast_types.doc -> (string, string) result
end

module EvalCtx = struct
  type t = { alias : Ctx.StringCtx.t; uop : Ctx.UopCtx.t }

  let create ~alias ~uop = { alias; uop }
end

module MakeWithExpsn (Expsn : Expansion.S) : S = struct
  open Common.Result

  module BufferWriter = Eval_impl.Make (struct
    type t = Buffer.t

    let rec eval ~alias ~uop doc =
      let buf = ok @@ Buffer.create 101 in
      (* TODO: performance issue *)
      let ctx = EvalCtx.create ~alias ~uop in
      List.fold_left
        (fun acc expr ->
          let+ buf = acc in
          let+ text = eval_expr ctx expr in
          Buffer.add_string buf text;
          Ok buf)
        buf doc

    and eval_expr ctx = function
      | Ast_types.Text s | White s -> Ok s
      | Group grp -> eval_group ctx grp
      | UnaryOp { op; group } -> eval_uop ctx op group
      | AliasDef _ | Unformat _ ->
          Error "parsed expr encountered during evaluation"

    and eval_group ctx grp =
      let+ grp' =
        List.fold_left
          (fun acc expr ->
            let+ lines = acc in
            let+ text = eval_expr ctx expr in
            Ok (text :: lines))
          (Ok []) grp
      in
      ok @@ String.concat "" grp'

    and eval_uop ctx op group =
      match Ctx.UopCtx.find ctx.EvalCtx.uop op with
      | None -> Error "undefined op" (* TODO: better error message. *)
      | Some f ->
          let+ egrp = eval_expr ctx group in
          ok @@ f egrp
  end)

  let eval doc =
    let+ buf = BufferWriter.eval doc ~alias:Expsn.alias ~uop:Expsn.uop in
    ok @@ Buffer.contents buf
end

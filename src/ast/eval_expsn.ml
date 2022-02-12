module type S = sig
  val eval : Ast_types.doc -> (string, string) result
end

module EvalCtx = struct
  type t = { alias : Ctx.StringCtx.t }

  let create ~alias = { alias }
end

module MakeWithExpsn (Expsn : Expansion.S) : S = struct
  open Common.Result

  module BufferWriter = Eval_impl.Make (struct
    type t = Buffer.t

    let rec eval alias doc =
      let buf = return @@ Buffer.create 101 in
      (* TODO: performance issue *)
      let ctx = EvalCtx.create ~alias in
      List.fold_left
        (fun acc expr ->
          let+ buf = acc in
          let+ text = eval_expr ctx expr in
          Buffer.add_string buf text;
          return buf)
        buf doc

    and eval_expr _ctx = function
      | Ast_types.Text str | White str -> Ok str
      | AliasDef _ | Unformat _ ->
          Error "parsed expr encountered during evaluation"
      | _ -> Ok "todo"
  end)

  let eval doc =
    let+ buf = BufferWriter.eval doc ~alias:Expsn.alias in
    return @@ Buffer.contents buf
end

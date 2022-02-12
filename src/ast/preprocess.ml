let rec pp_doc init_ctx doc =
  let rec loop ctx acc = function
    | [] -> (ctx, List.rev acc)
    | hd :: tl ->
        let ctx', expr' = pp_expr ctx hd in
        loop ctx' (expr' :: acc) tl
  in
  loop init_ctx [] doc

and pp_expr ctx =
  let open Ast_types in
  function
  | Text t ->
      let text = Option.value ~default:t @@ Ctx.StringCtx.find ctx t in
      (ctx, Text text)
  | Unformat u -> (ctx, Text u)
  | Group grp ->
      let ctx', grp' =
        List.fold_left
          (fun (ctx, acc) expr ->
            let ctx', expr' = pp_expr ctx expr in
            (ctx', expr' :: acc))
          (ctx, []) grp
      in
      (ctx', Group grp')
  | UnaryOp { op; group } ->
      let ctx', grp' = pp_expr ctx group in
      (ctx', UnaryOp { op; group = grp' })
  | AliasDef { name; value } ->
      let ctx' = Ctx.StringCtx.add name value ctx in
      (ctx', White "")
  | expr -> (ctx, expr)

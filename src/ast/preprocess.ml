type state = NewElem of Ast_types.expr | NewCtx of Ctx.StringCtx.t

let rec pp_doc init_ctx doc =
  let rec loop ctx acc = function
    | [] -> (ctx, List.rev acc)
    | hd :: tl -> (
        match pp_expr ctx hd with
        | NewCtx ctx' -> loop ctx' acc tl
        | NewElem expr' -> loop ctx (expr' :: acc) tl)
  in
  loop init_ctx [] doc

and pp_expr ctx = function
  | Ast_types.AliasDef { name; value } ->
      let ctx' = Ctx.StringCtx.add ctx name value in
      NewCtx ctx'
  | Text t ->
      let text = Option.value ~default:t @@ Ctx.StringCtx.find ctx t in
      NewElem (Text text)
  | Unformat u -> NewElem (Text u)
  | expr -> NewElem expr

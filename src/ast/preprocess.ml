type state = NewElem of Ast_types.expr | NewCtx of Context.t

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
      let ctx' = Context.add ctx name value in
      NewCtx ctx'
  | Text t -> NewElem (Text (Context.substitute ctx t))
  | Unformat u -> NewElem (Text u)
  | expr -> NewElem expr

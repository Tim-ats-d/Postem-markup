open Common

module type S = sig
  val check : Syntax.Parsed_ast.t -> (Ast.Types.doc, Err.checker_err) result
end

module Make (Expsn : Ast.Expansion.S) : S = struct
  open Result

  type state =
    | Expr of Ast.Types.expr
    | Expand of Ast.Types.expr * Ast.Types.expr

  let rec check parsed_ast =
    List.fold_left
      (fun acc expr ->
        let+ grp = acc in
        let+ expr' = pexpr expr in
        match expr' with
        | Expr e -> Ok (e :: grp)
        | Expand (e, e') -> Ok (e :: e' :: grp))
      (Ok [])
    @@ List.rev parsed_ast

  and pexpr =
    let open Ast.Types in
    let open Syntax.Parsed_ast in
    function
    | LNewline n -> ok @@ Expr (White n)
    | LText t ->
        let text =
          Option.value ~default:t @@ Ctx.AliasCtx.find_opt Expsn.alias t
        in
        ok @@ Expr (Text text)
    | LWhite w -> ok @@ Expr (White w)
    | LUnformat u -> ok @@ Expr (Unformat u)
    | LGroup g ->
        let+ grp =
          List.fold_left
            (fun acc expr ->
              let+ grp' = acc in
              let+ expr' = pexpr expr in
              match expr' with
              | Expr e -> Ok (e :: grp')
              | Expand (e, e') -> Ok (e :: e' :: grp'))
            (Ok []) g
        in
        ok @@ Expr (Group (List.rev grp))
    | LUnaryOp { op; group; newline } -> (
        match Ctx.UopCtx.find_opt Expsn.uop op.value with
        | None -> error @@ `UndefinedUop op.loc
        | Some _ -> (
            let+ group = pexpr group in
            match group with
            | Expr e when newline = "" ->
                ok @@ Expr (UnaryOp { op = op.value; group = e })
            | Expr e ->
                ok
                @@ Expand (UnaryOp { op = op.value; group = e }, White newline)
            | Expand (e, e') when newline = "" ->
                ok @@ Expr (UnaryOp { op = op.value; group = Group [ e; e' ] })
            | Expand (e, e') ->
                ok
                @@ Expand
                     ( UnaryOp { op = op.value; group = Group [ e; e' ] },
                       White newline )))
    | LBinOp _ -> assert false(* TODO *)
end

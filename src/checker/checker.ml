open Common

module type S = sig
  val check : Syntax.Parsed_ast.t -> (Ast.Types.doc, Err.checker_err) result
end

module Make (Expsn : Ast.Expansion.S) : S = struct
  open Result

  let rec check parsed_ast =
    List.rev parsed_ast
    |> List.fold_left
         (fun acc expr ->
           let+ grp = acc in
           let+ expr' = pexpr expr in
           Ok (expr' :: grp))
         (Ok [])

  and pexpr =
    let open Ast.Types in
    let open Syntax.Parsed_ast in
    function
    | LText t ->
        let text =
          Option.value ~default:t @@ Ctx.AliasCtx.find_opt Expsn.alias t
        in
        ok @@ Text text
    | LWhite w -> ok @@ White w
    | LUnformat u -> ok @@ Text u
    | LGroup g ->
        let+ grp =
          List.fold_left
            (fun acc expr ->
              let+ grp' = acc in
              let+ expr' = pexpr expr in
              Ok (expr' :: grp'))
            (Ok []) g
        in
        ok @@ Group (List.rev grp)
    | LUnaryOp { op; group } -> (
        match Ctx.UopCtx.find_opt Expsn.uop op.value with
        | None -> error @@ `UndefinedUop op.loc
        | Some _ ->
            let+ group = pexpr group in
            ok @@ UnaryOp { op = op.value; group })
end

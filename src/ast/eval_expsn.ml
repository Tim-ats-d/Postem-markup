open Ast_types

module type S = sig
  val eval : Ast_types.doc -> (string, string) result
end

module EvalCtx = struct
  type t = { alias : Ctx.StringCtx.t }

  let create ~alias = { alias }
end

module MakeWithExpsn (Expsn : Expansion.S) : S = struct
  module BufferWriter = Eval_impl.Make (struct
    type t = Buffer.t

    let rec eval alias doc =
      let buf = Result.ok @@ Buffer.create 101 in
      (* TODO: performance issue *)
      let ctx = EvalCtx.create ~alias in
      List.fold_left
        (fun acc expr ->
          Result.bind acc (fun buf ->
              Result.bind (eval_expr ctx expr) (fun text ->
                  Buffer.add_string buf text;
                  Ok buf)))
        buf doc

    and eval_expr _ctx = function
      | OpWord _ -> Ok "ow"
      | OpLine _ -> Ok "ol\n"
      | Text x | White x -> Ok x
      | AliasDef _ | Unformat _ ->
          Error "parsed expr encountered during evaluation"
  end)

  let eval doc =
    let result = BufferWriter.eval doc ~alias:Expsn.alias in
    Result.bind result (fun buf -> Result.ok @@ Buffer.contents buf)
end

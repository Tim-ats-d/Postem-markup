open Ast_types
open Utils

let preprocess initial_ctx (Document doc) =
  let rec process_elist ctx elist =
    let rec process_expr ctx = function
      | Alias (name, value) ->
          let ctx = Context.add ctx name value in
          (ctx, Text String.empty)
      | Text t -> (ctx, Text (Context.substitute ctx t))
      | Listing l ->
          let new_ctx, l' = process_elist ctx l in
          (new_ctx, Listing l')
      | Seq s ->
          let new_ctx, s' = process_elist ctx s in
          (new_ctx, Seq s')
      | Block b -> (
          match b with
          | Conclusion c ->
              let new_ctx, c' = process_expr ctx c in
              (new_ctx, Block (Conclusion c'))
          | Definition (name, value) ->
              let new_ctx, n = process_expr ctx name in
              let new_ctx, v = process_expr new_ctx value in
              (new_ctx, Block (Definition (n, v)))
          | Heading (lvl, h) ->
              let new_ctx, h' = process_expr ctx h in
              (new_ctx, Block (Heading (lvl, h')))
          | Quotation q ->
              let new_ctx, q' = process_expr ctx q in
              (new_ctx, Block (Quotation q')))
      | e -> (ctx, e)
    in
    List.fold_left_map process_expr ctx elist
  in
  process_elist initial_ctx doc |> snd

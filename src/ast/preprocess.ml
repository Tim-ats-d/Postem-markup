open Ast_types
open Utils

let preprocess initial_ctx (Document doc) =
  let rec process_elist ctx elist =
    let rec process_expr ctx = function
      | Alias (name, value) -> (Context.add ctx name value, Text String.empty)
      | Text t -> (ctx, Text (Context.substitute ctx t))
      | Listing l ->
          let ctx', l' = process_elist ctx l in
          (ctx', Listing l')
      | Seq s ->
          let ctx', s' = process_elist ctx s in
          (ctx', Seq s')
      | Block b -> (
          match b with
          | Conclusion c ->
              let ctx', c' = process_expr ctx c in
              (ctx', Block (Conclusion c'))
          | Definition (name, value) ->
              let ctx', n = process_expr ctx name in
              let ctx', v = process_expr ctx' value in
              (ctx', Block (Definition (n, v)))
          | Heading (lvl, h) ->
              let ctx', h' = process_expr ctx h in
              (ctx', Block (Heading (lvl, h')))
          | Quotation q ->
              let ctx', q' = process_expr ctx q in
              (ctx', Block (Quotation q')))
      | e -> (ctx, e)
    in
    List.fold_left_map process_expr ctx elist
  in
  process_elist initial_ctx doc |> snd

open Ast_types
open Env
open Utils

let preprocess initial_env (Document doc) =
  let rec process_elist env elist =
    let rec process_expr env = function
      | Alias (name, value) ->
          let ctx = Context.add env.ctx name value in
          ({ env with ctx }, Text String.empty)
      | Text t -> (env, Text (Context.substitute env.ctx t))
      | Listing l ->
          let new_env, l' = process_elist env l in
          (new_env, Listing l')
      | Seq s ->
          let new_env, s' = process_elist env s in
          (new_env, Seq s')
      | Block b -> (
          match b with
          | Conclusion c ->
              let new_env, c' = process_expr env c in
              (new_env, Block (Conclusion c'))
          | Definition (name, value) ->
              let new_env, n = process_expr env name in
              let new_env, v = process_expr new_env value in
              (new_env, Block (Definition (n, v)))
          | Heading (lvl, h) ->
              let new_env, h' = process_expr env h in
              (new_env, Block (Heading (lvl, h')))
          | Quotation q ->
              let new_env, q' = process_expr env q in
              (new_env, Block (Quotation q')))
      | e -> (env, e)
    in
    List.fold_left_map process_expr env elist
  in
  process_elist initial_env doc |> snd

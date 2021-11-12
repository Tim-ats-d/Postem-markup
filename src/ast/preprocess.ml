open Ast_types
open Utils

type preprocess_env = { ctx : Context.t; metadata : metadata }

and metadata = { headers : (int * expr) list }

let preprocess ctx (Document doc) =
  let rec process_elist env elist =
    let rec process_expr env =
      let { ctx; metadata } = env in
      function
      | Alias (name, value) ->
          let ctx = Context.add ctx name value in
          ({ env with ctx }, Text String.empty)
      | Text t -> (env, Text (Context.substitute ctx t))
      | Listing l ->
          let env', l' = process_elist env l in
          (env', Listing l')
      | Seq s ->
          let env', s' = process_elist env s in
          (env', Seq s')
      | Block b -> (
          match b with
          | Conclusion c ->
              let env', c' = process_expr env c in
              (env', Block (Conclusion c'))
          | Definition (name, value) ->
              let env', n = process_expr env name in
              let new_env, v = process_expr env' value in
              (new_env, Block (Definition (n, v)))
          | Heading (lvl, h) ->
              let env', h' = process_expr env h in
              ( {
                  env' with
                  metadata = { headers = (lvl, h) :: metadata.headers };
                },
                Block (Heading (lvl, h')) )
          | Quotation q ->
              let env', q' = process_expr env q in
              (env', Block (Quotation q')))
      | e -> (env, e)
    in
    List.fold_left_map process_expr env elist
  in
  process_elist { ctx; metadata = { headers = [] } } doc
  |> fun ({ metadata; _ }, elist) -> (metadata, elist)

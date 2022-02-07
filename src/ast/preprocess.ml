open Ast_types

type env = { ctx : Context.t; metadata : metadata }
and metadata = { headers : (Share.TitleLevel.t * expr list) list }

let fold_map = List.fold_left_map

let rec pp_doc ctx doc =
  let init_env = { ctx; metadata = { headers = [] } } in
  let env, doc' = fold_map pp_expr init_env doc in
  (env.metadata, doc')

and pp_expr env = function
  | AliasDef { name; value } ->
      let ctx = Context.add env.ctx name value in
      ({ env with ctx }, Text "")
  | Text t -> (env, Text (Context.substitute env.ctx t))
  | Unformat u -> (env, Text u)
  | expr -> (env, expr)

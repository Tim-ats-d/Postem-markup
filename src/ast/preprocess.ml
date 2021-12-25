open Ast_types

type env = { ctx : Context.t; metadata : metadata }

and metadata = { headers : (Share.TitleLevel.t * expr list) list }

let fold_map = List.fold_left_map

let rec ppdoc ctx doc =
  let init_env = { ctx; metadata = { headers = [] } } in
  let env, doc' = fold_map ppelement init_env doc in
  (env.metadata, doc')

and ppelement env : expr element -> env * atom element = function
  | Block b ->
      let env', b' = ppblock env b in
      (env', Block b')
  | Paragraph p ->
      let env', p' = fold_map ppexpr env p in
      (env', Paragraph p')

and ppblock env = function
  | Conclusion c ->
      let env', c' = fold_map ppexpr env c in
      (env', Conclusion c')
  | Definition (name, value) ->
      let env', name' = fold_map ppexpr env name in
      let env'', value' = fold_map ppexpr env' value in
      (env'', Definition (name', value'))
  | Heading (lvl, h) ->
      let env', h' = fold_map ppexpr env h in
      ( { env' with metadata = { headers = (lvl, h) :: env'.metadata.headers } },
        Heading (lvl, h') )
  | Quotation q ->
      let env', q' = fold_map ppexpr env q in
      (env', Quotation q')

and ppexpr env = function
  | `AliasDef (name, value) ->
      let ctx = Context.add env.ctx name value in
      ({ env with ctx }, `Text "")
  | `Text t -> (env, `Text (Context.substitute env.ctx t))
  | #atom as a -> (env, a)

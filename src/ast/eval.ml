open Ast_types

let subsitute ctx text = Utils.String.split_map_join (Context.get ctx) text

let rec eval ctx (Prog p) =
  List.filter_map (eval_expr ctx) p |> String.concat "\n"

and eval_expr ctx = function
  | Alias (name, value) ->
      Context.add ctx name value;
      None
  | Marker (f, args) -> Some (f args)
  | Text text -> Some (subsitute ctx text)
  | Block (e, e') ->
      Misc.Option.merge ( ^ ) (eval_expr ctx e) (eval_expr ctx e')

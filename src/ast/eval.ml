open Ast_types
open Utils

let subsitute = Context.find

let rec eval ctx (Document doc) =
  List.filter_map (eval_expr ctx) doc |> String.concat "\n"

and eval_expr ctx = function
  | Text text -> subsitute ctx text |> Option.some
  | White (i, w) ->
      Pprint.string_of_whitespace w |> String.make i |> Option.some
  | Int i -> string_of_int i |> Option.some
  | Alias (name, value) ->
      Context.add ctx name value;
      None
  | Marker _ -> None
  | Block (fst, rest) ->
      Option.merge ( ^ ) (eval_expr ctx fst) (eval_expr ctx rest)

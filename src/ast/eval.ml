open Ast_types
open Utils

let subsitute = Context.find

let rec eval ctx (Document doc) =
  List.filter_map (eval_expr ctx) doc |> String.concat "\n\n"

and eval_expr ctx =
  let module O = Option in
  function
  | Alias (name, value) ->
      Context.add ctx name value;
      None
  | Block b -> eval_block ctx b
  | Int i -> string_of_int i |> O.some
  | Text text -> subsitute ctx text |> O.some
  | Seq l -> List.filter_map (eval_expr ctx) l |> String.join |> O.some
  | White (i, w) -> Pprint.string_of_whitespace w |> String.make i |> O.some

and eval_block ctx = function
  | Quotation e -> eval_expr ctx e

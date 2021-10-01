open Ast_types
open Utils
module O = Option

module type EXT = Ext.Expansion.S

let subsitute = Context.find

let rec eval filename (module Expansion : EXT) (Document doc) =
  List.filter_map (eval_expr (module Expansion : EXT) Context.empty) doc
  |> String.concat "\n\n" |> Ext.Document.create filename |> Expansion.postprocess

and eval_expr (module Ext : EXT) ctx =
  let eval_expr_ext = eval_expr (module Ext) in
  function
  | Alias (name, value) ->
      Context.add ctx name value;
      None
  | Block b -> eval_block (module Ext : EXT) ctx b
  | Int i -> string_of_int i |> O.some
  | Include filename ->
      if File.is_exist filename then Some (File.read_all filename) else None
  | Listing l -> List.filter_map (eval_expr_ext ctx) l |> Ext.listing |> O.some
  | Text text -> subsitute ctx text |> O.some
  | Seq l -> List.filter_map (eval_expr_ext ctx) l |> String.join |> O.some
  | White (i, w) -> Pprint.whitespace i w |> O.some

and eval_block (module Ext : EXT) ctx =
  let eval_expr_ext = eval_expr (module Ext) in
  let split_opt = O.map (String.split_on_char '\n') in
  function
  | Definition (name, values) -> (
      match eval_expr_ext ctx name with
      | None -> None
      | Some n ->
          O.map (Ext.definition n) (split_opt (eval_expr_ext ctx values)))
  | Heading (lvl, h) -> eval_expr_ext ctx h |> O.map (Ext.heading lvl)
  | Quotation q -> O.map Ext.quotation (eval_expr_ext ctx q |> split_opt)

open Ast_types
open Utils

module type EXT = Ext.Expansion.S

let rec eval ?ext:((module Expansion : EXT)=(module Ext.Expansion.Default)) filename (Document doc) =
  let eval_expr_with_ext = eval_expr (module Expansion : EXT) Context.empty in
  List.map eval_expr_with_ext doc |> Expansion.concat_block |> Ext.Document.create filename |> Expansion.postprocess

and eval_expr (module Ext : EXT) ctx =
  let eval_expr_ext = eval_expr (module Ext) in
  function
  | Alias (name, value) ->
      Context.add ctx name value;
      String.empty
  | Block b -> eval_block (module Ext : EXT) ctx b
  | Int i -> string_of_int i
  | Include filename ->
      if File.is_exist filename then File.read_all filename else String.empty
  | Listing l -> List.map (eval_expr_ext ctx) l |> Ext.listing
  | Text text -> Context.find ctx text
  | Seq l -> List.map (eval_expr_ext ctx) l |> String.join
  | White (i, w) -> eval_whitespace i w

and eval_block (module Ext : EXT) ctx =
  let eval_expr_ext = eval_expr (module Ext) in
  function
  | Conclusion c -> Ext.conclusion (eval_expr_ext ctx c)
  | Definition (name, values) ->
    let name' = eval_expr_ext ctx name
    and values' = eval_expr_ext ctx values in
    values' |> String.split_lines |> Ext.definition name'
  | Heading (lvl, h) -> eval_expr_ext ctx h |> Ext.heading lvl
  | Quotation q -> Ext.quotation (eval_expr_ext ctx q |> String.split_lines)

and eval_whitespace i chr =
  String.make i
  @@
  match chr with
  | CarriageReturn -> '\r'
  | Newline -> '\n'
  | Tab -> '\t'
  | Space -> ' '
  | Unknown c -> c

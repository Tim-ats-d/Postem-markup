open Ast_types
open Utils

module type EXT = Ext.Expansion.S
module DefaultEXT = Ext.Expansion.Default

let rec eval ?ext:((module Expsn : EXT)=(module DefaultEXT)) filename document =
  Preprocess.preprocess Expsn.initial_alias document
  |> eval_elist (module Expsn : EXT)
  |> Expsn.concat_block
  |> Ext.Document.create filename
  |> Expsn.postprocess

and eval_elist (module Ext : EXT) = List.map (eval_expr (module Ext: EXT))

and eval_expr (module Ext : EXT) = function
  | Alias _ -> String.empty
  | Block b -> eval_block (module Ext : EXT) b
  | Int i -> string_of_int i
  | Include filename ->
      if File.is_exist filename then File.read_all filename else String.empty
  | Listing l -> eval_elist (module Ext) l |> Ext.listing
  | Text t -> t
  | Seq l -> eval_elist (module Ext) l |> String.join
  | Unformat u -> u
  | White (i, w) -> eval_whitespace i w

and eval_block (module Ext : EXT) =
  let eval_expr_ext = eval_expr (module Ext) in
  function
  | Conclusion c -> eval_expr_ext c |> Ext.conclusion
  | Definition (name, values) ->
      let name' = eval_expr_ext name and values' = eval_expr_ext values in
      values' |> String.split_lines |> Ext.definition name'
  | Heading (lvl, h) -> eval_expr_ext h |> Ext.heading lvl
  | Quotation q -> eval_expr_ext q |> String.split_lines |> Ext.quotation

and eval_whitespace i chr =
  String.make i
  @@
  match chr with
  | CarriageReturn -> '\r'
  | Newline -> '\n'
  | Tab -> '\t'
  | Space -> ' '
  | Unknown c -> c

open Ast_types
open Utils

module type EXT = Ext.Expansion.S


(* TODO: Handle block type *)
let preprocess initial_ctx (Document doc) =
  let rec process_elist ctx elist =
    let loop ctx = function
      | Alias (name, value) -> (Context.add ctx name value, Text String.empty)
      | Text t -> (ctx, Text (Context.substitute ctx t))
      | Listing l ->
          let ctx', l' = process_elist ctx l in
          (ctx', Listing l')
      | Seq s ->
          let ctx', s' = process_elist ctx s in
          (ctx', Seq s')
      | e -> (ctx, e)
    in
    List.fold_left_map loop ctx elist
in process_elist initial_ctx doc |> snd

let rec eval ?ext:((module Expansion : EXT)=(module Ext.Expansion.Default)) filename document =
  preprocess Expansion.initial_alias document
  |> List.map (eval_expr (module Expansion : EXT))
  |> Expansion.concat_block |> Ext.Document.create filename |> Expansion.postprocess

and eval_expr (module Ext : EXT) =
  let eval_expr_ext = eval_expr (module Ext) in
  function
  | Alias _ -> String.empty
  | Block b -> eval_block (module Ext : EXT) b
  | Int i -> string_of_int i
  | Include filename ->
      if File.is_exist filename then File.read_all filename else String.empty
  | Listing l -> List.map eval_expr_ext l |> Ext.listing
  | Text t -> t
  | Seq l -> List.map eval_expr_ext l |> String.join
  | White (i, w) -> eval_whitespace i w

and eval_block (module Ext : EXT) =
  let eval_expr_ext = eval_expr (module Ext) in
  function
  | Conclusion c -> eval_expr_ext c |> Ext.conclusion
  | Definition (name, values) ->
    let name' = eval_expr_ext name
    and values' = eval_expr_ext values in
    values' |> String.split_lines |> Ext.definition name'
  | Heading (lvl, h) -> eval_expr_ext h |> Ext.heading lvl
  | Quotation q -> Ext.quotation (eval_expr_ext q |> String.split_lines)

and eval_whitespace i chr =
  String.make i
  @@
  match chr with
  | CarriageReturn -> '\r'
  | Newline -> '\n'
  | Tab -> '\t'
  | Space -> ' '
  | Unknown c -> c

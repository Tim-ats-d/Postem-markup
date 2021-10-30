open Ast_types
open Utils

module type EXPSN = Expansion.Type.S

let rec eval (module Expsn : EXPSN) filename document =
  let env = Env.create ~ctx:Expsn.initial_alias in
  Preprocess.preprocess env document
  |> eval_elist (module Expsn : EXPSN)
  |> List.filter (fun x -> x <> String.empty)
  |> Expsn.concat
  |> Ext.Postprocess.create filename
  |> Expsn.postprocess

and eval_elist (module Expsn : EXPSN) =
  List.map (eval_expr (module Expsn : EXPSN))

and eval_expr (module Expsn : EXPSN) = function
  | Alias _ -> String.empty
  | Block b -> eval_block (module Expsn : EXPSN) b
  | Int i -> string_of_int i
  | Include filename ->
      if Sys.file_exists filename then File.read_all filename else String.empty
  | Listing l -> eval_elist (module Expsn) l |> Expsn.listing
  | Text t -> t
  | Seq l -> eval_elist (module Expsn) l |> String.join |> Expsn.paragraph
  | Unformat u -> u
  | White w -> eval_whitespace w

and eval_block (module Expsn : EXPSN) =
  let eval_expr_ext = eval_expr (module Expsn) in
  function
  | Conclusion c -> eval_expr_ext c |> Expsn.conclusion
  | Definition (name, values) ->
      let name' = eval_expr_ext name and values' = eval_expr_ext values in
      values' |> String.split_lines |> Expsn.definition name'
  | Heading (lvl, h) -> eval_expr_ext h |> Expsn.heading lvl
  | Quotation q -> eval_expr_ext q |> String.split_lines |> Expsn.quotation

and eval_whitespace = function
  | CarriageReturn -> "\r"
  | Newline -> " "
  | Tab -> "\t"
  | Space -> " "
  | Unknown c -> Char.to_string c

open Ast_types
open Utils

exception Missing_file of Lexing.position * string

exception Missing_meta of string

module type EXPSN = Expansion.Type.S

let rec eval (module Expsn : EXPSN) filename document =
  let env = Env.create ~ctx:Expsn.initial_alias in
  Preprocess.preprocess env document
  |> eval_elist (module Expsn : EXPSN)
  |> List.filter (fun x -> x <> String.empty)
  |> Expsn.Misc.concat
  |> Ext.Postprocess.create filename
  |> Expsn.Misc.postprocess

and eval_elist (module Expsn : EXPSN) =
  List.map (eval_expr (module Expsn : EXPSN))

and eval_expr (module Expsn : EXPSN) = function
  | Alias _ -> String.empty
  | Block b -> eval_block (module Expsn : EXPSN) b
  | Int i -> string_of_int i
  | Include (pos, fname) ->
      if Sys.file_exists fname then File.read_all fname
      else raise (Missing_file (pos, fname))
  | Listing l -> eval_elist (module Expsn) l |> Expsn.Tags.listing
  | Meta (name, content) -> eval_meta (module Expsn : EXPSN) name content
  | Text t -> t
  | Seq l -> eval_elist (module Expsn) l |> String.join |> Expsn.Tags.paragraph
  | Unformat u -> u
  | White w -> eval_whitespace w

and eval_block (module Expsn : EXPSN) =
  let eval_expr_ext = eval_expr (module Expsn) in
  function
  | Conclusion c -> eval_expr_ext c |> Expsn.Tags.conclusion
  | Definition (name, values) ->
      let name' = eval_expr_ext name and values' = eval_expr_ext values in
      values' |> String.split_lines |> Expsn.Tags.definition name'
  | Heading (lvl, h) -> eval_expr_ext h |> Expsn.Tags.heading lvl
  | Quotation q -> eval_expr_ext q |> String.split_lines |> Expsn.Tags.quotation

and eval_meta (module Expsn : EXPSN) name content =
  match List.assoc_opt name Expsn.meta with
  | None -> Missing_meta name |> raise
  | Some mode -> (
      match mode with
      | `Inline f -> f (String.trim content)
      | `Lines f -> f (String.split_lines content)
      | `Paragraph f -> f content)

and eval_whitespace = function
  | CarriageReturn -> "\r"
  | Newline -> " "
  | Tab -> "\t"
  | Space -> " "
  | Unknown c -> Char.to_string c

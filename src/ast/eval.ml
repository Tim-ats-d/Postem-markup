open Ast_types
open Utils

exception Missing_file of Lexing.position * string

exception Missing_meta of string

let rec eval (module Expsn : Expansion.Type.S) filename document =
  let exec_env = Env.create (module Expsn) in
  Preprocess.preprocess Expsn.initial_alias document |> eval_elist exec_env
  (* |> Postprocess.postprocess (fun _ -> "toc") exec_env.metadata *)
  |> List.filter (( <> ) String.empty)
  |> Expsn.Misc.concat
  |> Ext.Statistic.from_file filename
  |> Expsn.Misc.postprocess

and eval_elist env = List.map (eval_expr env)

and eval_expr env =
  let { Env.expsn = (module Expsn); _ } = env in
  function
  | Alias _ -> String.empty
  | Block b -> eval_block env b
  | Int i -> string_of_int i
  | Include (pos, fname) -> eval_include pos fname
  | Listing l -> eval_elist env l |> Expsn.Tags.listing
  | Meta (name, content) -> eval_meta env name content
  | Text t -> t
  | Seq l -> eval_elist env l |> String.join |> Expsn.Tags.paragraph
  | Unformat u -> u
  | White w -> eval_whitespace w

and eval_block env =
  let { Env.expsn = (module Expsn); _ } = env in
  function
  | Conclusion c -> eval_expr env c |> Expsn.Tags.conclusion
  | Definition (name, values) ->
      let name' = eval_expr env name and values' = eval_expr env values in
      values' |> String.split_lines |> Expsn.Tags.definition name'
  | Heading (lvl, h) ->
      let h' = eval_expr env h in
      env.metadata.headers <- (lvl, h') :: env.metadata.headers;
      h' |> Expsn.Tags.heading lvl
  | Quotation q -> eval_expr env q |> String.split_lines |> Expsn.Tags.quotation

and eval_include position filename =
  if Sys.file_exists filename then File.read_all filename
  else raise (Missing_file (position, filename))

and eval_meta { expsn = (module Expsn); _ } name content =
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

open Ast_types
open Utils

exception Missing_metamark of Ast_types.loc * string

module type S = sig
  val eval : Ast_types.expr list -> string
end

module MakeWithExpsn (Expsn : Expansion.S) = struct
  module W = Eval_impl.Make (struct
    type t = string

    let rec eval meta doc = List.map (eval_expr meta) doc

    and eval_expr meta = function
      | Alias _ -> String.empty
      | Block b -> eval_block meta b
      | Listing l -> eval meta l |> Expsn.Tags.listing
      | MetamarkArgs (pos, name, content) -> eval_meta_args pos name content
      | MetamarkSingle (pos, name) -> eval_meta_single pos name
      | Text t -> t
      | Seq l -> eval meta l |> Text.Lines.join |> Expsn.Tags.paragraph
      | Unformat u -> u
      | Whitespace w -> w

    and eval_block meta = function
      | Conclusion c -> eval_expr meta c |> Expsn.Tags.conclusion
      | Definition (name, values) ->
          let name' = eval_expr meta name and values' = eval_expr meta values in
          values' |> String.split_lines |> Expsn.Tags.definition name'
      | Heading (lvl, h) ->
          let num = Expsn.numerotation lvl in
          num#next;
          eval_expr meta h |> Expsn.Tags.heading num#get lvl
      | Quotation q ->
          eval_expr meta q |> String.split_lines |> Expsn.Tags.quotation

    and eval_meta_args pos name content =
      match List.assoc_opt name Expsn.Meta.args with
      | None -> raise (Missing_metamark (pos, name))
      | Some mode -> (
          match mode with
          | `Inline f -> f (String.trim content)
          | `Lines f -> f (String.split_lines content)
          | `Paragraph f -> f content)

    and eval_meta_single pos name =
      match List.assoc_opt name Expsn.Meta.single with
      | None -> raise (Missing_metamark (pos, name))
      | Some f -> f ()
  end)

  let eval doc = W.eval doc ~alias:Expsn.initial_alias |> Expsn.postprocess
end

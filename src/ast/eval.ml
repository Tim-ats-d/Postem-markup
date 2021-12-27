open Ast_types
open Utils

exception Missing_metamark of Ast_types.loc * string

module type S = sig
  val eval : Ast_types.expr document -> string
end

module MakeWithExpsn (Expsn : Expansion.S) = struct
  module StringWriter = Eval_impl.Make (struct
    type t = string

    let rec eval meta (doc : value document) = List.map (eval_elem meta) doc

    and eval_elem meta = function
      | Block b -> eval_block meta b
      | Paragraph p -> Expsn.Tags.paragraph @@ eval_alist p

    and eval_alist alist = Text.Lines.join @@ List.map eval_atom alist

    and eval_atom = function
      | `MetamarkArgs (pos, { name; value }) -> eval_meta_args pos name value
      | `MetamarkSingle (pos, name) -> eval_meta_single pos name
      | `Text t -> t
      | `Unformat u -> u
      | `Whitespace w -> w

    and eval_block _meta = function
      | Conclusion c -> Expsn.Tags.conclusion @@ eval_alist c
      | Definition (name, values) ->
          let name' = eval_alist name and values' = eval_alist values in
          values' |> String.split_lines |> Expsn.Tags.definition name'
      | Heading (lvl, h) ->
          let num = Expsn.numerotation lvl in
          num#next;
          Expsn.Tags.heading num#get lvl @@ eval_alist h
      | Quotation q -> Expsn.Tags.quotation @@ List.map eval_atom q

    and eval_meta_args pos name content =
      match List.assoc_opt name Expsn.Meta.args with
      | None -> raise @@ Missing_metamark (pos, name)
      | Some mode -> (
          let open Share.MetaMode in
          match mode with
          | Inline f -> f @@ String.trim content
          | Lines f -> f @@ String.split_lines content
          | Paragraph f -> f content)

    and eval_meta_single pos name =
      match List.assoc_opt name Expsn.Meta.single with
      | None -> raise @@ Missing_metamark (pos, name)
      | Some f -> f ()
  end)

  let eval doc =
    Expsn.postprocess @@ StringWriter.eval doc ~alias:Expsn.initial_alias
end

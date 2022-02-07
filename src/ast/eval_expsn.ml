open Ast_types

exception Missing_metamark of Ast_types.loc * string

module type S = sig
  val eval : Ast_types.doc -> string
end

module MakeWithExpsn (Expsn : Expansion.S) = struct
  module StringWriter = Eval_impl.Make (struct
    type t = string

    let rec eval meta doc = List.map (eval_expr meta) doc

    and eval_expr _meta = function
      | AliasDef _ | Unformat _ -> assert false
      | Text t -> t
      | UnaryOpWord _ -> "uow"
      | UnaryOpLine _ -> "uol\n"
      | White w -> w
  end)

  let eval doc =
    Expsn.postprocess @@ StringWriter.eval doc ~alias:Expsn.initial_alias
end

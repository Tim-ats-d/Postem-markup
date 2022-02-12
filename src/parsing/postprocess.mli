module type S = sig
  val postprocess : Parsed_ast.t -> (Ast.Types.doc, Common.Err.t) result
end

module Make : functor (Expsn : Ast.Expansion.S) -> S

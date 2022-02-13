module type S = sig
  val pass :
    Syntax.Parsed_ast.t -> (Ast.Types.doc, Common.Err.checker_err) result
end

module Make : functor (Expsn : Ast.Expansion.S) -> S

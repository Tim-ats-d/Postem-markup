module type S = sig
  val check :
    Syntax.Parsed_ast.t -> (Ast.Types.doc, Common.Err.checker_err) result
end

module Make : functor (Expsn : Ast.Expansion.S) -> S

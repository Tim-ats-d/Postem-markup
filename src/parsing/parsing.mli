module type S = sig
  val parse : Sedlexing.lexbuf -> (Ast.Types.expr list, Common.Err.t) result
end

module Make : functor (Expsn : Ast.Expansion.S) -> S

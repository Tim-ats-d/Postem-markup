module type S = sig
  val parse : Sedlexing.lexbuf -> (Parsed_ast.t, Common.Err.t) result
  (** [parse lexbuf] returns [Ok past] if parsing goes smoothly, [Error err]
    otherwise. *)
end

module Parser : S
(** Default implementation of the parser. *)

module Parsed_ast = Parsed_ast

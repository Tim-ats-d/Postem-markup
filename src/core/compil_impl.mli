(** Input signature of the functor [Compil_impl.Make]. *)
module type Interpr = sig
  type t

  val eval : Ast.Ast_types.expr Ast.Ast_types.document -> t
end

(** Output signature of the functor [Compil_impl.Make]. *)
module type S = sig
  type t
  (** The outputed type. *)

  val from_lexbuf : Lexing.lexbuf -> (t, string) result
  (** [from_lexbuf lexbuf] returns [Ok output] if compilation goes smoothly,
       [Error msg] otherwise. *)

  val from_string : string -> (t, string) result
  (** [from_string str] is [from_lexbuf (Lexing.from_string str)]. *)

  val from_file : string -> (t, string) result
  (** [from_file filename ] does the same as [from_str] execept it compiles the
    content of file [filename]. *)
end

module Make : functor (Eval : Interpr) -> S with type t := Eval.t

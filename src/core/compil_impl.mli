(** Input signature of the functor [Compil_impl.Make]. *)
module type PARSER = sig
  val parse : Sedlexing.lexbuf -> (Ast.Ast_types.doc, string) result
end

(** Input signature of the functor [Compil_impl.Make]. *)
module type EVAL = sig
  type t

  val eval : Ast.Ast_types.doc -> t
end

(** Output signature of the functor [Compil_impl.Make]. *)
module type S = sig
  type t
  (** The outputed type. *)

  val from_lexbuf : ?filename:string -> Sedlexing.lexbuf -> (t, string) result
  (** [from_lexbuf lexbuf] returns [Ok output] if compilation goes smoothly,
      [Error msg] otherwise. Optional argument [filename] is used to indicate
      in the file name in error messages in case of an error *)

  val from_string : ?filename:string -> string -> (t, string) result

  val from_channel : ?filename:string -> in_channel -> (t, string) result
  (** [from_file chan] does the same as [from_str] execept it compiles the
    content of file [chan]. *)
end

module Make : functor (Parser : PARSER) (Eval : EVAL) -> S with type t := Eval.t

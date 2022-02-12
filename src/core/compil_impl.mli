(** Input signature of the functor [Compil_impl.Make]. *)
module type EVAL = sig
  type t

  val eval : Ast.Types.doc -> t
end

(** Output signature of the functor [Compil_impl.Make]. *)
module type S = sig
  type t
  (** The outputed type. *)

  val from_lexbuf :
    ?filename:string -> Sedlexing.lexbuf -> (t, Common.Err.t) result
  (** [from_lexbuf lexbuf] returns [Ok output] if compilation goes smoothly,
      [Error msg] otherwise. Optional argument [filename] is used to indicate
      in the file name in error messages in case of an error *)

  val from_string : ?filename:string -> string -> (t, Common.Err.t) result

  val from_channel : ?filename:string -> in_channel -> (t, Common.Err.t) result
  (** [from_file chan] does the same as [from_str] execept it compiles the
    content of file [chan]. *)
end

module Make : functor (Parser : Parsing.S) (Eval : EVAL) ->
  S with type t := Eval.t

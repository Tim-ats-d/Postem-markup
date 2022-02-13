(** Containing utilities for error message formatting. *)

(** {1 Types} *)

type checker_err = [ `UndefinedUop of Lexing.position * Lexing.position ]
type expsn_err = [ `ExpsnAmbiguity of string | `UnknownExpsn of string ]

type parser_err =
  [ `IllegalCharacter of Sedlexing.lexbuf | `SyntaxError of Sedlexing.lexbuf ]

type t = [ checker_err | expsn_err | parser_err | `NoSuchFile of string ]

(** {2 API} *)

val to_string : t -> string

val pp_string : ?hint:string -> string -> string
(** [pp_string msg] prettifies and returns it as string. *)

(** Containing utilities for error message formatting. *)

(** {1 Types} *)

type loc = Lexing.position * Lexing.position
type checker_err = [ `UndefinedUop of loc ]
type expsn_err = [ `ExpsnAmbiguity of string | `UnknownExpsn of string ]
type parser_err = [ `IllegalCharacter of loc | `SyntaxError of loc ]
type t = [ checker_err | expsn_err | parser_err | `NoSuchFile of string ]

(** {2 API} *)

val to_string : t -> string

val pp_string : ?hint:string -> string -> string
(** [pp_string msg] prettifies and returns it as string. *)

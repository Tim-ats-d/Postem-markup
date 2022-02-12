(** Containing utilities for error message formatting. *)

(** {1 Types} *)

type t =
  [ `IllegalCharacter of string
  | `SyntaxError of string
  | `UndefinedUop of Lexing.position * Lexing.position ]

(** {2 API} *)

val to_string : t -> string

val pp_string : ?hint:string -> string -> string
(** [pp_string msg] prettifies and returns it as string. *)

val pp_position : ?hint:string -> msg:string -> Lexing.position -> string
(** [pp_position pos ~msg] prettifies [pos] and returns it as string.*)

val pp_lexbuf : Sedlexing.lexbuf -> msg:string -> string
(** [pp_lexbuf lexbuf ~msg] prettifies [lexbuf] and returns it as string. *)

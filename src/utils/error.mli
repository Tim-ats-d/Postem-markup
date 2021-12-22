(** A module containing utilities for error message formatting. *)

type t = string

val of_string : msg:string -> t
(** [of_string ~msg] prettifies and returns it as string. *)

val of_position :
  ?cursor_length:int -> ?hint:string -> Lexing.position -> msg:string -> t
(** [of_position pos ~msg] prettifies [pos] and returns it as string.*)

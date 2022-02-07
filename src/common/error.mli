(** Containing utilities for error message formatting. *)

(** {1 Type} *)

type t = string

(** {2 API} *)

val of_string : ?hint:string -> string -> t
(** [of_string msg] prettifies and returns it as string. *)

val of_position :
  ?cursor_length:int -> ?hint:string -> Lexing.position -> msg:string -> t
(** [of_position pos ~msg] prettifies [pos] and returns it as string.*)

val of_lexbuf : Sedlexing.lexbuf -> msg:string -> t
(** [of_lexbuf lexbuf ~msg] prettifies [lexbuf] and returns it as string. *)

(** Some extension to OCaml stdlib. *)

(** Extension to the [Result] module of the OCaml stdlib. *)
module Result : sig
  include module type of Result

  val ( let+ ) : ('a, 'b) t -> ('a -> ('c, 'b) t) -> ('c, 'b) t
  val return : 'a -> ('a, 'b) t
end

(** Containing utilities for file io. *)
module File : sig
  val read_all : string -> string
  (** [read_all filename] returns the content of file [filename] as a string.
       @raise Sys_error if filename does not exist. *)

  val write : string -> string -> unit
  (** [write filename str] writes [str] in file [filename].
    Create file [filename] if it does not exist. *)
end

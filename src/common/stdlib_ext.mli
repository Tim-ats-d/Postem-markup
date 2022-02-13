(** Some extension to OCaml stdlib. *)

val prerr_with_exit : string -> 'a
(** Print on stderr given string and exit with code 1. *)

(** Extension to the [Result] module of the OCaml stdlib. *)
module Result : sig
  include module type of Result

  val ( let+ ) : ('a, 'b) t -> ('a -> ('c, 'b) t) -> ('c, 'b) t
end

(** Containing utilities for in_channel io. *)
module In_channel : sig
  val write : string -> string -> unit
  (** [write filename str] writes [str] in file [filename].
    Create file [filename] if it does not exist. *)
end

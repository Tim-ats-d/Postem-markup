(** {1 Type} *)

type t = {
  mutable input_file : string;
  mutable output_file : string;
  mutable expansion : string;
  mutable output_on_stdout : bool;
}
(** Type representing CLI argument passed by user. *)

(** {2 API} *)

val parse : on_empty:(t -> unit) -> t
(** [parse ~on_empty:f] returns CLI arguments passed as type [t]. [f] received
passed arguments and is executed if no positional arguments are passed.
*)

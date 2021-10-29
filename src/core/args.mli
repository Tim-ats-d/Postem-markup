(** {1 Type} *)

type t = {
  mutable input_file : string;
  mutable output_file : string;
  mutable expansion : string;
  mutable output_on_stdout : bool;
}
(** Type representing CLI argument passed by user. *)

(** {2 API} *)

val parse : unit -> t
(** Parse CLI arguments and returns them as type [t]. *)

(** {1 Type} *)

type t = {
  input_file : string;
  output_file : string;
  expansion : string;
  output_on_stdout : bool;
}
(** Type representing CLI argument passed by user. *)

(** {2 API} *)

val parse : unit -> t
(** Parse CLI arguments and returns them as type [t]. *)

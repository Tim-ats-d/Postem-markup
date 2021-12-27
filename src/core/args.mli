(** {1 Type} *)

type t =
  < input_file : string
  ; output_file : string
  ; expansion : string
  ; output_on_stdout : bool >
(** Type representing CLI argument passed by user. *)

(** {2 API} *)

class args :
  object
    val input_file : string

    val output_file : string

    val expansion : string

    val output_on_stdout : bool

    method input_file : string

    method output_file : string

    method expansion : string

    method output_on_stdout : bool

    method set_input_file : string -> unit

    method set_output_file : string -> unit

    method set_expansion : string -> unit

    method set_output_on_stdout : bool -> unit
  end

val parse : on_empty:(args -> unit) -> t
(** [parse ~on_empty:f] returns CLI arguments passed as type [t].
  [f] is executed if no positional arguments are passed. *)

(** {1 Type} *)

type t =
  < direct_input : string
  ; input_file : string
  ; output_file : string
  ; expansion : string
  ; output_on_stdout : bool >
(** Type representing CLI argument passed by user. *)

(** {2 API} *)

class args :
  object
    val direct_input : string

    val input_file : string

    val output_file : string

    val expansion : string

    val output_on_stdout : bool

    method direct_input : string

    method input_file : string

    method output_file : string

    method expansion : string

    method output_on_stdout : bool

    method set_direct_input : string -> unit

    method set_input_file : string -> unit

    method set_output_file : string -> unit

    method set_expansion : string -> unit

    method set_output_on_stdout : bool -> unit
  end

val parse : unit -> t
(** Returns CLI arguments passed as type [t]. *)

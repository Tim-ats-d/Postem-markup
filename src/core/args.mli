(** {1 Type} *)

type t =
  < direct_input : string
  ; inputf : string
  ; outputf : string
  ; expsn : string
  ; output_on_stdout : bool >
(** Type representing CLI argument passed by user. *)

(** {2 API} *)

class args :
  object
    val direct_input : string

    val inputf : string

    val outputf : string

    val expsn : string

    val output_on_stdout : bool

    method direct_input : string

    method inputf : string

    method outputf : string

    method expsn : string

    method output_on_stdout : bool

    method set_direct_input : string -> unit

    method set_inputf : string -> unit

    method set_outputf : string -> unit

    method set_expsn : string -> unit

    method set_output_on_stdout : bool -> unit
  end

val parse : unit -> t
(** Returns CLI arguments passed as type [t]. *)

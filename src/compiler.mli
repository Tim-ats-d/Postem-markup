(** {1 API} *)

module Repl : sig
  val launch : (string -> (string, Common.Err.t) result) -> unit
  (** [launch_repl eval] launches a REPL using [eval] function to generate
    evaluate input.

    The REPL lets type until <CTRL + D> is pressed, compile this input, displays the output and exit. *)
end

val compile : unit -> unit
(** Compile the document passed at CLI and write result on a file or on stdout
  according to CLI argument. *)

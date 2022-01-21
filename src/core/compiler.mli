(** {1 API} *)

module Repl : sig
  val launch : (string -> (string, string) result) -> unit
  (** [launch_repl eval] launches a REPL using [eval] function to generate
    evaluate input.

    The REPL lets type until <CTRL + D> is pressed, compile this input, displays the output and exit. *)
end

module Parser : Compil_impl.PARSER
(** The default implementation of the parser. *)

val compile : unit -> unit
(** Compile the document passed at CLI and write result on a file or on stdout
  according to CLI argument. *)

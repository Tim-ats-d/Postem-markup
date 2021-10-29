val from_str :
  ?filename:string ->
  (module Expansion.Type.S) ->
  string ->
  (string, string) result
(** [from_str expansion str] returns [Ok output] if compilation goes smoothly, [Error msg] otherwise.
    [expansion] is the module used to generate the rendering.
    Optional paramater [filename] is used to set the name of filename.
*)

val from_file :
  (module Expansion.Type.S) -> Utils.File.t -> (string, string) result
(** [from_file filename expansion] does the same as [from_str] execept it compiles the content of file [filename]. *)

val launch_repl : (module Expansion.Type.S) -> unit
(** [launch_repl expansion] launches a REPL using [expansion] to generate the rendering.

The REPL lets type until <CTRL + D> is pressed, compile this input, displays the output and exit.
*)

val compile : unit -> unit
(** Compile the document passed at CLI and write result on a file or on stdout according to CLI argument. *)

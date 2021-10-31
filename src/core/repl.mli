val launch : (string -> (string, string) result) -> unit
(** [launch_repl eval] launches a REPL using [eval] function to generate evaluate input.

The REPL lets type until <CTRL + D> is pressed, compile this input, displays the output and exit.
*)

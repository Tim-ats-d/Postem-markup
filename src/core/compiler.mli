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
  Utils.File.t -> (module Expansion.Type.S) -> (string, string) result
(** [from_file filename expansion] does the same as [from_str] execept it compiles the content of file [filename]. *)

val compile : unit -> unit
(** Compile the document passed at CLI and write result on a file or on stdout according to CLI argument. *)

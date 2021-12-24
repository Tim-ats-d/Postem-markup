val from_lexbuf :
  Lexing.lexbuf -> (module Ast.Expansion.S) -> (string, string) result
(** [from_lexbuf lexbuf expansion] returns [Ok output] if compilation goes smoothly, [Error msg] otherwise.
    [expansion] is the module used to generate the rendering. *)

val from_str : string -> (module Ast.Expansion.S) -> (string, string) result
(** [from_str str expansion ] is [from_lexbuf (Lexing.from_string str) expsn]. *)

val from_file :
  Utils.File.t -> (module Ast.Expansion.S) -> (string, string) result
(** [from_file filename expansion] does the same as [from_str] execept it compiles the content of file [filename]. *)

val compile : unit -> unit
(** Compile the document passed at CLI and write result on a file or on stdout according to CLI argument. *)

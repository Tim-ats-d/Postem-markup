(** {1 API} *)

val from_lexbuf :
  Lexing.lexbuf -> (module Ast.Expansion.S) -> (string, string) result
(** [from_lexbuf lexbuf expsn] returns [Ok output] if compilation goes smoothly, [Error msg] otherwise.
    [expsn] is the module used to generate the rendering. *)

val from_string : string -> (module Ast.Expansion.S) -> (string, string) result
(** [from_string str expsn] is [from_lexbuf (Lexing.from_string str) expsn]. *)

val from_file :
  Utils.File.t -> (module Ast.Expansion.S) -> (string, string) result
(** [from_file filename expsn] does the same as [from_str] execept it compiles the content of file [filename]. *)

val compile : unit -> unit
(** Compile the document passed at CLI and write result on a file or on stdout according to CLI argument. *)

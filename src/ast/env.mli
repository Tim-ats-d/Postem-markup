(** {1 Type} *)

type t = { expsn : (module Expansion.Type.S); metadata : metadata }
(** The type representing an execution environment. *)

and metadata = { mutable headers : (int * string) list }
(** The type representing data gleaned on AST. *)

(** {2 API} *)

val create : (module Expansion.Type.S) -> t
(** [create expsn] returns a fresh execution environment where the expansion is set to [expsn]. *)

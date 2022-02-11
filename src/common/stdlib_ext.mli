(** Some extension of OCaml stdlib. *)

(** Extension of the [Char] module of the OCaml stdlib. *)
module Char : sig
  include module type of Char

  val to_string : char -> string
  (** [to_string c] is [c] turned into a string. *)
end

(** Extension of the [String] module of the OCaml stdlib. *)
module String : sig
  include module type of String

  val empty : string
  (** [empty] is [""]. *)

  val is_empty : string -> bool
  (** [is_empty str] tests if [str] is empty. *)

  val split_lines : string -> string list
  (** [split_lines str] is [String.split_on_char '\n' str]. *)
end

(** Containing utilities for file. *)
module File : sig
  type t = string
  (** A type alias for file.  *)

  val read_all : t -> string
  (** [read_all filename] returns the content of file [filename] as a string.
       @raise Sys_error if filename does not exist.
     *)

  val write : t -> string -> unit
  (** [write filename str] writes [str] in file [filename]. Create file [filename] if it does not exist. *)
end
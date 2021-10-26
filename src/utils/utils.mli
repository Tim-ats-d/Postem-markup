module Char : sig
  include module type of Char

  val to_string : char -> string

  val concat : char list -> string
end

module String : sig
  include module type of String

  val empty : string

  val is_empty : string -> bool

  val of_chars : char list -> string

  val to_chars : string -> char list

  val concat_first : string -> string list -> string

  val join : string list -> string

  val split_lines : string -> string list
end

module File : sig
  type t = string

  val read_all : t -> string

  val write : t -> string -> unit
end

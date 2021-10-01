module Option : sig
  include module type of Option

  val merge : ('a -> 'a -> 'a) -> 'a option -> 'a option -> 'a option
end

module Char : sig
  include module type of Char

  val to_string : char -> string

  val is_alpha : char -> bool

  val is_num : char -> bool

  val is_symbol : char -> bool
end

module String : sig
  include module type of String

  val is_empty : string -> bool

  val of_chars : char list -> string

  val to_chars : string -> char list

  val concat_first : string -> string list -> string

  val join : string list -> string

  val strip_first : string -> string

  val split_lines : string -> string list
end

module File : sig
  type t = string

  val is_exist : string -> bool

  val read_all : string -> string
end

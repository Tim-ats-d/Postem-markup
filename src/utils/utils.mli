module Option : sig
  include module type of Option

  val merge : ('a -> 'a -> 'a) -> 'a option -> 'a option -> 'a option
end

module Char : sig
  include module type of Char

  val to_string : char -> string

  val is_alpha : char -> bool

  val is_digit : char -> bool
end

module String : sig
  include module type of String

  val is_empty : string -> bool

  val of_chars : char list -> string

  val to_chars : string -> char list

  val strip_first : string -> string
end

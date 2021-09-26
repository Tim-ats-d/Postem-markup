module Int : sig
  include module type of Int

  val range : int -> int -> int list
end

module List : sig
  include module type of List

  val run_length_encoding : (int -> 'a -> 'b) -> 'a list -> 'b list
end

module Option : sig
  include module type of Option

  val merge : ('a -> 'a -> 'a) -> 'a option -> 'a option -> 'a option
end

module Char : sig
  include module type of Char

  val to_string : char -> string

  val is_alpha : char -> bool

  val is_digit : char -> bool

  val is_space : char -> bool

  val ( -- ) : char -> char -> char list
end

module String : sig
  include module type of String

  val is_empty : string -> bool

  val of_chars : char list -> string

  val to_chars : string -> char list

  val join : char -> string list -> string

  val strip_first : string -> string

  val split_map_join : ?on:char -> (string -> string) -> string -> string
end

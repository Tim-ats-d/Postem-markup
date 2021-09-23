module Int : sig
  val range : int -> int -> int list
end

module Option : sig
  val merge : ('a -> 'a -> 'a) -> 'a option -> 'a option -> 'a option
end

module Char : sig
  val to_string : char -> string

  val is_space : char -> bool

  val ( -- ) : char -> char -> char list
end

module String : sig
  val is_empty : string -> bool

  val join : char -> string list -> string

  val split_map_join : ?on:char -> (string -> string) -> string -> string
end

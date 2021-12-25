module type ALIAS_MAP = sig
  include module type of Map.Make (Utils.String)
end

module AliasMap : ALIAS_MAP

module MetaMode : sig
  type t =
    | Inline of (string -> string)
    | Lines of (string list -> string)
    | Paragraph of (string -> string)
end

module Numerotation : sig
  type t = < get : string ; next : unit >
end

module TitleLevel : sig
  type t = T1 | T2 | T3 | T4 | T5 | T6

  val to_int : t -> int

  val of_int : int -> t
end

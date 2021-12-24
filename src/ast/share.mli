module TitleLevel :
  sig
    type t = T1 | T2 | T3 | T4 | T5 | T6
    val to_int : t -> int
    val of_int : int -> t
  end
module Numerotation : sig type t = < get : string; next : unit > end

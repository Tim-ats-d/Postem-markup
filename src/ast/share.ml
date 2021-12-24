module type ALIAS_MAP = sig
  include module type of Map.Make (Utils.String)
end

module AliasMap = Map.Make (Utils.String)

module Numerotation = struct
  type t = < next : unit ; get : string >
end

module TitleLevel = struct
  type t = T1 | T2 | T3 | T4 | T5 | T6

  let to_int = function
    | T1 -> 1
    | T2 -> 2
    | T3 -> 3
    | T4 -> 4
    | T5 -> 5
    | T6 -> 6

  let of_int = function
    | 1 -> T1
    | 2 -> T2
    | 3 -> T3
    | 4 -> T4
    | 5 -> T5
    | 6 -> T6
    | _ -> raise @@ Invalid_argument "Must be between 1 and 6"
end

module type S = sig
  type t
  type key
  type value

  val empty : t
  val add : key -> value -> t -> t
  val find : t -> key -> value option
  val merge : t -> t -> t
end

module type VALUE = sig
  type t
end

module Make (Ord : Map.OrderedType) (Value : VALUE) :
  S with type key := Ord.t and type value := Value.t = struct
  module Map = Map.Make (Ord)

  type t = Value.t Map.t

  let empty = Map.empty
  let add = Map.add
  let find t x = Map.find_opt x t

  let merge a b =
    Map.merge (fun _ s s' -> match s with None -> s' | Some _ -> s) a b
end

module StringCtx = Make (String) (String)

module UopCtx =
  Make
    (String)
    (struct
      type t = string -> string
    end)

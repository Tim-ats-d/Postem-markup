(** {1 API} *)

(** Output signature of the functor [Ctx.Make]. *)
module type S = sig
  type t
  type key
  type value

  val empty : t
  val add : t -> key -> value -> t
  val find : t -> key -> value option
  val merge : t -> t -> t
end

module type VALUE = sig
  type t
end

(** Functor building a context  given a totally ordered type and a value. *)
module Make : functor (Ord : Map.OrderedType) (Value : VALUE) ->
  S with type key := Ord.t and type value := Value.t

module StringCtx : S with type key := string and type value := string

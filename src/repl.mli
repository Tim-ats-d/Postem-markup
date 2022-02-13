module type S = sig
  val launch : unit -> unit
end

module Make : functor (Compiler : Core.Compil_impl.S with type t := string) -> S

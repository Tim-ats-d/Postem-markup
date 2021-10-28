module type S = sig
  val initial_alias : string Map.Make(Utils.String).t

  val concat : string list -> string

  val conclusion : string -> string

  val definition : string -> string list -> string

  val heading : int -> string -> string

  val paragraph : string -> string

  val quotation : string list -> string

  val listing : string list -> string

  val postprocess : Ext.Postprocess.t -> string
end

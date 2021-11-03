module type Tags = sig
  val conclusion : string -> string

  val definition : string -> string list -> string

  val heading : int -> string -> string

  val paragraph : string -> string

  val quotation : string list -> string

  val listing : string list -> string
end

module type Misc = sig
  val concat : string list -> string

  val postprocess : Ext.Statistic.t -> string
end

module type S = sig
  val initial_alias : string Map.Make(Utils.String).t

  val meta :
    (string
    * [> `Inline of string -> string
      | `Lines of string list -> string
      | `Paragraph of string -> string ])
    list

  module Tags : Tags

  module Misc : Misc
end

module type Tags = sig
  val conclusion : string -> string

  val definition : string -> string list -> string

  val heading : string -> Share.TitleLevel.t -> string -> string

  val paragraph : string -> string

  val quotation : string list -> string

  val listing : string list -> string
end

module type Meta = sig
  val args :
    (string
    * [> `Inline of string -> string
      | `Lines of string list -> string
      | `Paragraph of string -> string ])
    list

  val single : (string * (unit -> string)) list
end

module type S = sig
  val postprocess : string list -> string

  val initial_alias : string Share.AliasMap.t

  val numerotation : Share.TitleLevel.t -> Share.Numerotation.t

  module Tags : Tags

  module Meta : Meta
end

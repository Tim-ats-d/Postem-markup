module AliasMap : sig
  include module type of Map.Make (Common.String)
end

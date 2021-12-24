class virtual enumerator :
  Base.numbering
  -> object
       val mutable numeration : Base.numbering

       method numeration : Base.numbering

       method set_num : Base.numbering -> unit

       method enum : ?formatter:(string -> string -> string) -> string -> string
     end

module Base = Base
module Builtins = Builtins

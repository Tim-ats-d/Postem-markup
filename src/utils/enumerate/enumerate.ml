class virtual enumerator (num : Base.numbering) =
  object
    val mutable numeration = num

    method numeration = numeration

    method set_num n = numeration <- n

    method enum ?(formatter = Printf.sprintf "%s %s") str =
      formatter str @@ numeration#get
  end

module Base = Base
module Builtins = Builtins

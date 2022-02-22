class virtual numerotation =
  object
    method virtual next : unit

    method virtual get : string
  end

class virtual alphabet letters =
  object
    inherit numerotation

    val mutable n = 0

    method next = if n < Array.length letters then n <- n + 1 else n <- 1
    (* Start again. *)

    method get = letters.(n - 1)
  end

  class virtual roman (`I i) (`V v) (`X x) (`L l) (`C c) (`D d) (`M m) =
  object (self)
    inherit numerotation

    val mutable n = 0

    method private digit x y z = function
      | 1 -> [ x ]
      | 2 -> [ x; x ]
      | 3 -> [ x; x; x ]
      | 4 -> [ x; y ]
      | 5 -> [ y ]
      | 6 -> [ y; x ]
      | 7 -> [ y; x; x ]
      | 8 -> [ y; x; x; x ]
      | 9 -> [ x; z ]
      | _ -> assert false

    method private to_roman n =
      if n = 0 then []
      else if n < 0 then assert false
      else if n >= 1000 then m :: self#to_roman (n - 1000)
      else if n >= 100 then self#digit c d m (n / 100) @ self#to_roman (n mod 100)
      else if n >= 10 then self#digit x l c (n / 10) @ self#to_roman (n mod 10)
      else self#digit i v x n

    method next = n <- n + 1

    method get = String.concat "" @@ self#to_roman n
  end

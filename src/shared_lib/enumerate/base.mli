(** Containing utility classes to build the [Builtins] module. *)

(** {1 API} *)

(** A virtual class used to structure inheritance. *)
class virtual numerotation :
  object
    method virtual get : string
    (** Returns current letter as a string. *)

    method virtual next : unit
    (** Advances in the unfolding of the alphabet. *)
  end

(** [alphabet] takes a string array representing the letters of an alphabet.

When the last letter is reached, start again at the first and so on. *)
class virtual alphabet :
  string array
  -> object
       method get : string

       method next : unit
     end

(** [roman] takes representing the different letters of the roman alphabet.

When the last letter is reached, start again at the first and so on. *)
class virtual roman :
  [< `I of string ]
  -> [< `V of string ]
  -> [< `X of string ]
  -> [< `L of string ]
  -> [< `C of string ]
  -> [< `D of string ]
  -> [< `M of string ]
  -> object
       method get : string

       method next : unit
     end

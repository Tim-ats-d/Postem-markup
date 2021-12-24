class virtual numbering :
  object
    method virtual get : string

    method virtual next : unit
  end

class virtual alphabet :
  string array
  -> object
       method get : string

       method next : unit
     end

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

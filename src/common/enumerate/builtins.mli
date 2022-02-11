(** {1 API} *)

(** The null numbering. *)
class null :
  object
    method get : string

    method next : unit
    (** Returns always an empty string. *)
  end

class numeric_arab :
  object
    method get : string
    method next : unit
  end

class lower_case_numeric_roman :
  object
    method get : string
    method next : unit
  end

class upper_case_numeric_roman :
  object
    method get : string
    method next : unit
  end

class lower_case_latin :
  object
    method get : string
    method next : unit
  end

class upper_case_latin :
  object
    method get : string
    method next : unit
  end

class lower_case_greek :
  object
    method get : string
    method next : unit
  end

class upper_case_greek :
  object
    method get : string
    method next : unit
  end

class lower_case_cyrillic :
  object
    method get : string
    method next : unit
  end

class upper_case_cyrillc :
  object
    method get : string
    method next : unit
  end

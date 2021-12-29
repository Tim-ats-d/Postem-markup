class null =
  object
    inherit Base.numerotation

    method next = ()

    method get = ""
  end

class numeric_arab =
  object
    inherit Base.numerotation

    val mutable current = 0

    method next = current <- current + 1

    method get = Int.to_string current
  end

class lower_case_numeric_roman =
  object
    inherit
      Base.roman (`I "i") (`V "v") (`X "x") (`L "l") (`C "c") (`D "d") (`M "m")
  end

class upper_case_numeric_roman =
  object
    inherit
      Base.roman (`I "I") (`V "V") (`X "X") (`L "L") (`C "C") (`D "D") (`M "M")
  end

class lower_case_latin =
  object
    inherit
      Base.alphabet
        (Array.init 26 (fun i -> String.make 1 @@ Char.chr @@ (i + 97)))
  end

class upper_case_latin =
  object
    inherit
      Base.alphabet
        (Array.init 26 (fun i -> String.make 1 @@ Char.chr @@ (i + 65)))
  end

class lower_case_greek =
  object
    inherit
      Base.alphabet
        [|
          "α";
          "β";
          "γ";
          "δ";
          "ε";
          "ζ";
          "η";
          "θ";
          "ι";
          "κ";
          "λ";
          "μ";
          "ν";
          "ξ";
          "ο";
          "π";
          "ρ";
          "σ";
          "τ";
          "υ";
          "φ";
          "χ";
          "ψ";
          "ω";
        |]
  end

class upper_case_greek =
  object
    inherit
      Base.alphabet
        [|
          "Α";
          "Β";
          "Γ";
          "Δ";
          "Ε";
          "Ζ";
          "Η";
          "Θ";
          "Ι";
          "Κ";
          "Λ";
          "Μ";
          "Ν";
          "Ξ";
          "Ο";
          "Π";
          "Ρ";
          "Σ";
          "Τ";
          "Υ";
          "Φ";
          "Χ";
          "Ψ";
          "Ω";
        |]
  end

class lower_case_cyrillic =
  object
    inherit
      Base.alphabet
        [|
          "а";
          "б";
          "в";
          "г";
          "д";
          "е";
          "ё";
          "ж";
          "з";
          "и";
          "й";
          "і";
          "к";
          "л";
          "м";
          "н";
          "о";
          "п";
          "р";
          "с";
          "т";
          "у";
          "ф";
          "х";
          "ц";
          "ч";
          "ш";
          "щ";
          "ъ";
          "ы";
          "ь";
          "ѣ";
          "э";
          "ю";
          "я";
          "ѳ";
          "ѵ";
        |]
  end

class upper_case_cyrillc =
  object
    inherit
      Base.alphabet
        [|
          "А";
          "Б";
          "В";
          "Г";
          "Д";
          "Е";
          "Ё";
          "Ж";
          "З";
          "И";
          "Й";
          "и";
          "І";
          "К";
          "Л";
          "М";
          "Н";
          "О";
          "П";
          "Р";
          "С";
          "Т";
          "У";
          "Ф";
          "Х";
          "Ц";
          "Ч";
          "Ш";
          "Щ";
          "Ъ";
          "Ы";
          "Ь";
          "Ѣ";
          "Э";
          "Ю";
          "Я";
          "Ѳ";
          "Ѵ";
        |]
  end

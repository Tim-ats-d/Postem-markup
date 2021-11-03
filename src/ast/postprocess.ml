type t = Complet of string | Todo

let complet str = Complet str

let todo = Todo

let postprocess f { Env.headers } =
  List.map (function Complet d -> d | Todo -> f headers)

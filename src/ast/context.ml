type t = (string, string) Hashtbl.t

let create () = Hashtbl.create 42

let empty = create ()

let add = Hashtbl.add

let find hastbl str = Hashtbl.find_opt hastbl str |> Option.value ~default:str

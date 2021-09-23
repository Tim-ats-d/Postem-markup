type t = (string, string) Hashtbl.t

let create () = Hashtbl.create 42

let add h x y = Hashtbl.add h x y

let get hastbl x = Hashtbl.find_opt hastbl x |> Option.value ~default:x

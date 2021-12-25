module StringMap = Map.Make (Utils.String)

type t = string StringMap.t

let empty = StringMap.empty

let add t name value = StringMap.add name value t

let substitute t str = StringMap.find_opt str t |> Option.value ~default:str

let merge =
  (fun _ s0 s1 -> match s0 with None -> s1 | Some _ -> s0) |> StringMap.merge

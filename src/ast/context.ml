module StringMap = Map.Make (Common.String)

type t = string StringMap.t

let empty = StringMap.empty
let add t name value = StringMap.add name value t
let substitute t str = Option.value ~default:str @@ StringMap.find_opt str t

let merge =
  StringMap.merge @@ fun _ s s' -> match s with None -> s' | Some _ -> s

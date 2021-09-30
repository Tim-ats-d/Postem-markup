module type S = sig
  val preprocess : string -> string

  val postprocess : Document.t -> string
end

module Default : S = struct
  let preprocess = Fun.id

  let postprocess { Document.content; _ } = content
end

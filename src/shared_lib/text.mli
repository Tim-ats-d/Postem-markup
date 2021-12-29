(** High-level text and string list manipulation. *)

(** {1 Type} *)

type t = string

(** {2 API} *)

val prefix : t -> t -> t
(** [prefix pre str] is [pre ^ str]. *)

val suffix : t -> t -> t
(** [suffix str suf] is [str ^ suf]. *)

val between : t -> t -> t -> t
(** [between a b c ] is [a ^ b ^ c]. *)

module Lines : sig
  type nonrec t = t list

  val concat : string -> t -> string
  (** [concat] is [String.concat]. *)

  val concat_fst : string -> t -> string
  (** [concat_fst sep lines] is [sep ^ String.concat sep lines]. *)

  val concat_lines : t -> string
  (** [concat_lines lines] is [String.concat "\n"]. *)

  val join : t -> string
  (** [join lines] is [String.concat "" lines]. *)

  val join_lines : t -> string
  (** [join_lines lines] is [String.concat "\n" lines]. *)

  val prefix : string -> t -> t
  (** [prefix str lines] is [List.map (Text.prefix str)]. *)

  val suffix : string -> t -> t
  (** [suffix str lines] is [List.map (fun line -> suffix line str)]. *)
end

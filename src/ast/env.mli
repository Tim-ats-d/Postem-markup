(** {1 Type} *)

type t = {
  ctx : Context.t;  (** Execution context. *)
  headers : (int * string) list;
      (** Headers of a document in the form [(level, content)]. *)
}
(** The type representing an execution environment. *)

(** {2 API} *)

val create : ctx:Context.t -> t
(** [create ctx] returns a fresh execution environment where the context is set to [ctx]. *)

let prerr_with_exit err =
  prerr_endline err;
  exit 1

module In_channel = struct
  let write filename str =
    let oc = open_out filename in
    output_string oc str;
    close_out oc
end

module Result = struct
  include Result

  let ( let+ ) = Result.bind
end

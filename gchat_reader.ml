open Ppx_yojson_conv_lib.Yojson_conv
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

module Creator = struct
  type t =
    { name : string
    ; email : string
    ; user_type : string
    }
  [@@deriving yojson]
end

module Format_metadata = struct
  type t = { format_type : string } [@@deriving yojson]
end

module Url = struct
  type t = { private_do_not_access_or_else_safe_url_wrapped_value : string }
  [@@deriving yojson]
end

module Url_metadata = struct
  type t =
    { title : string
    ; snippet : string
    ; image_url : string
    ; url : Url.t
    }
  [@@deriving yojson]
end

module Youtube_metadata = struct
  type t =
    { id : string
    ; start_time : int
    }
  [@@deriving yojson]
end

module Annotation = struct
  type t =
    { start_index : int
    ; length : int
    ; format_metadata : Format_metadata.t option [@yojson.option]
    ; url_metadata : Url_metadata.t option [@yojson.option]
    ; youtube_metadata : Youtube_metadata.t option [@yojson.option]
    }
  [@@deriving yojson]
end

module Attached_file = struct
  type t =
    { original_name : string
    ; export_name : string
    }
  [@@deriving yojson]
end

module Message = struct
  (* attached_files or text are always there, we could improve this *)
  type t =
    { creator : Creator.t
    ; created_date : string
    ; text : string option [@yojson.option]
    ; topic_id : string
    ; annotations : Annotation.t list option [@yojson.option]
    ; attached_files : Attached_file.t list option [@yojson.option]
    }
  [@@deriving yojson]
end

module Log = struct
  type t = { messages : Message.t list } [@@deriving yojson]
end

let handle_json json =
  try
    let log : Log.t = Log.t_of_yojson json in
    Format.eprintf "Read %d messages@\n" (List.length log.messages)
  with
  | Of_yojson_error (exn, obj) ->
    let exn_msg = Printexc.to_string exn in
    let obj_msg = Yojson.Safe.to_string obj in
    Format.eprintf "Error reading messages %s in %s@\n" exn_msg obj_msg
  | exn ->
    let exn_msg = Printexc.to_string exn in
    Format.eprintf "Error reading messages %s@\n" exn_msg

let go file =
  Format.eprintf "Processing file: %s@\n" file;
  Stdlib.In_channel.with_open_text file (fun ic ->
      handle_json (Yojson.Safe.from_channel ic))

let () =
  if Array.length Sys.argv != 2 then (
    Format.eprintf "Wrong number of arguments";
    exit 1)
  else
    let file = Sys.argv.(1) in
    go file

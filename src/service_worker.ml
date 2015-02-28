
let version = "1.0"

class type installEvent = object
  inherit Dom_html.event 

  (* Wait install until successful callback. *)
  method waitUntil: 'a -> unit Js.meth
end

class type _request = object
  method url: Js.js_string Js.t Js.readonly_prop
  method _Method: Js.js_string Js.t Js.readonly_prop
end

class type _response = object
end

class type fetchEvent = object
  inherit Dom_html.event

  method respondWith_promise: Promise.promise Js.t -> unit Js.meth
  method respondWith_response: _response Js.t -> unit Js.meth
  method default: _request Js.t -> 'a Js.meth
  method request: _request Js.t Js.readonly_prop
end

(* Define events for service worker *)
module Service_worker_events = struct
  let install : installEvent Js.t Dom_html.Event.typ = Dom_html.Event.make "install"
  let fetch : fetchEvent Js.t Dom_html.Event.typ = Dom_html.Event.make "fetch"
end

module Service_worker : sig
  val install: ((installEvent as 'b) Js.t -> bool Js.t) -> Dom_html.event_listener_id
  val fetch: ((fetchEvent as 'b) Js.t -> bool Js.t) -> Dom_html.event_listener_id
end = struct
  module Event = Service_worker_events

  let addEvent e h =
    let h = Dom_html.handler h in
    let open Js in
    Dom_html.addEventListener Dom_html.window e h _false

  let install handler = addEvent Event.install handler
  let fetch handler = addEvent Event.fetch handler
end

let _Response : (Js.js_string Js.t -> _response Js.t) Js.constr = Js.Unsafe.global##_Response

let () = ignore begin
  let console = Console.console in
  Service_worker.install (fun _ ->
    let open Js in
    console##log (string ("installed " ^ version)); _false) |> ignore;

  Service_worker.fetch (fun e ->
    let url = Js.to_string e##request##url |> Url.url_of_string in
    match url with
    | None -> assert false
    | Some url -> begin match url with
      | Url.Http url | Url.Https url when url.Url.hu_path_string <> "" ->
         let response = "You access to " ^ url.Url.hu_path_string in
         let res = jsnew (_Response) ((Js.string response)) in
         e##respondWith_response (res) |> ignore;
      | _ -> e##default (e##request)
    end;
      Js._false
  ) |> ignore;
end

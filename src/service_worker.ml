open Js

class type installEvent = object
  inherit Dom_html.event 

  (* Wait install until successful callback. *)
  method waitUntil: 'a -> unit meth
end

class type _request = object
  method url: js_string t readonly_prop
  method _Method: js_string t readonly_prop
end

class type fetchEvent = object
  inherit Dom_html.event

  method respondWith: 'a -> unit meth
  method default: unit -> 'a meth
  method request: _request t readonly_prop
end

(* Define events for service worker *)
module Service_worker_events = struct
  let install : installEvent t Dom_html.Event.typ = Dom_html.Event.make "install"
  let fetch : fetchEvent t Dom_html.Event.typ = Dom_html.Event.make "fetch"
end

module Service_worker : sig
  val install: ((installEvent as 'b) t -> bool t) -> Dom_html.event_listener_id
  val fetch: ((fetchEvent as 'b) t -> bool t) -> Dom_html.event_listener_id
end = struct
  module Event = Service_worker_events

  let addEvent e h =
    let h = Dom_html.handler h in
    Dom_html.addEventListener Dom_html.window e h _false

  let install handler = addEvent Event.install handler
  let fetch handler = addEvent Event.fetch handler
end

let () =
  Service_worker.install (fun _ -> _false) |> ignore

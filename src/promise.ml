open Js

class type promise = object
  method _then: ('a t -> unit) -> promise t meth
  method _catch: ('a t -> unit) -> promise t meth
end

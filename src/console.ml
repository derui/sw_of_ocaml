open Js

class type console = object
  method log : 'a t -> unit meth
end

let console : console t = Unsafe.variable "console"

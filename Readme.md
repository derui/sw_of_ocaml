# Service Worker of OCaml #
This is study implementation via js_of_ocaml for [Service Worker](http://www.w3.org/TR/2015/WD-service-workers-20150205/) 

## Requirement ##

- OMake
- js_of_ocaml

## Build ##

You execute command follows at cloned directory.

```
$ cd sw_of_ocaml
$ omake copy
```

## Run sample ##

```
$ cd sw_of_ocaml/misc
$ http-server 

and access http://localhost:8080. You can view Service Worker status if your main browser is support Service Worker, what is Chrome or Firefox
If not installed [http-server](https://github.com/nodeapps/http-server), you can use `python -m SimpleHTTPServer` instead of it.
```


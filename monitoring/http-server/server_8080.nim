import asynchttpserver, asyncdispatch, json, asyncfile, os

var server = newAsyncHttpServer()

proc cb(req: Request) {.async.} =
  var p = paramStr(1)
  var file = openAsync($p, fmRead)
  file.setFilePos(0)
  let data = await file.readAll()
  let headers = newHttpHeaders([("Content-Type","application/json")])
  let jsonNode = parseJson($data)
  await req.respond(Http200, $jsonNode, headers)
  file.close()

waitFor server.serve(Port(8080), cb)
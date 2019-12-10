import asynchttpserver, asyncdispatch, json, asyncfile, os, strutils

var server = newAsyncHttpServer()

proc cb(req: Request) {.async.} =
  var p = paramStr(2)
  try:
    var file = openAsync($p, fmRead)
    file.setFilePos(0)
    let data = await file.readAll()
    try:
      let jsonNode = parseJson($data)
      let headers = newHttpHeaders([("Content-Type","application/json")])
      await req.respond(Http200, $jsonNode, headers)
      file.close()
    except JsonParsingError:
      echo "Cannot parce json file",$p
      await req.respond(Http200, "Cannot parse json file " & $p)
      sleep(1000)
  except OSError:
    await req.respond(Http200, "Cannot open file " & $p)
    echo "Cannot open file ",$p
    sleep(1000)
try:
  waitFor server.serve(Port(parseInt(paramStr(1))), cb)
except OSError:
  echo getCurrentExceptionMsg()

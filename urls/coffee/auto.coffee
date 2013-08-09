http = require "http"
uri=
  hostname: "nodejs.org"
  port: 80
  path: "/dist/latest"
content = ""
req = http.request uri, (res) ->
  res.setEncoding("utf8")
  res.on "data", (chunk) ->
    content += chunk
  res.on "end", () -> console.log content
req.end()

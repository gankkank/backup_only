fs = require "fs"

fs.readFile "./template/apt-get", (err, data) ->
  array = data.toString().replace(/^#.*/, '').trim().split("[")
  json = for str in array
    if ! str then continue
    tmp=str.split("]")
    name=tmp[0]
    config=tmp[1]
    { name: name, config: config }
  console.log json

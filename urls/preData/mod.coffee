query = (data) ->
  console.log "this is query: #{data}"

class Search
  type: ->
    query(db)
    console.log "hello"

module.exports = (db) ->
  new Search

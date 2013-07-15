module.exports = (db) ->
  home = ->
  home::index = (req, res) -> 
    res.send "welcome to home"
  new home

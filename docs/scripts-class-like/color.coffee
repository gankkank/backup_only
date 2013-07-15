#how to use:
#echo = require("./color").echo
#echo.red "./configure --prefix=/opt/scripts --user=support"

class Cecho
  constructor: () ->
    @ansi_info = "\u001b[47;1;30m"
    @ansi_err = "\u001b[41;1;30m"
    @ansi_red="\u001b[31m"
    @ansi_blue = "\u001b[34m"
    @ansi_cyan = "\u001b[36m"
    @ansi_yellow = "\u001b[33m"
    @ansi_purple = "\u001b[35m"
    @ansi_black = "\u001b[30m"
    @reset="\u001b[0m"
  red: (data) ->  console.log @ansi_red + data + @reset
  blue: (data) -> console.log @ansi_blue + data + @reset
  cyan: (data) -> console.log @ansi_cyan + data + @reset
  yellow: (data) -> console.log @ansi_yellow + data + @reset
  purple: (data) -> console.log @ansi_purple + data + @reset
  info: (data) -> console.log @ansi_info + data + @reset
  err: (data) -> console.log @ansi_err + data + @reset
  black: (data) -> console.log @ansi_black + data + @reset

exports.echo = new Cecho


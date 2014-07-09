#
exec = require("child_process").exec
fs = require "fs"
path = require "path"

class gkmControl
  constructor: (@hostUrl="http://192.168.56.201:3000") ->
    #console.log @hostUrl
    @gk3_cookie = "/root/.gk/gk3.dev.cookie"

  checkLogin: (cb) ->
    loginUrl = "#{@hostUrl}/signin"
    okUrl = "#{@hostUrl}/ok"
    gk2_config = "/root/.gk/config"
    fs.readFile gk2_config, (err, data) ->
      query = data.toString().trim().split('\n').join('&').replace(/user/,"username").replace(/pass/,"password")
      cmd_login = "curl -X POST -c #{@gk3_cookie} -d \"#{query}\" #{loginUrl}"
      exec cmd_login, (err, result) -> console.log err if err
      exec "curl -b #{@gk3_cookie} #{okUrl}", (err, result) ->
        #console.log result
        if result is "ok"
          cb true
        else
          cb false

  postRequest: (query, cb) ->
    reqUrl = "#{@hostUrl}/gkm/request/new"
    command = "curl -b #{@gk3_cookie} -X POST -H 'Content-Type: application/json' -d \'#{JSON.stringify(query)}\' #{reqUrl}"
    exec command, (err,result) ->
      if result is "ok" then cb true else cb false

  readTemplate: (tmplPath, cb) ->
    #command="cat #{tmplPath} | grep -v "^#" | grep -v "^$""
    #exec command
    fs.readFile tmplPath, (err, data) ->
      #json = for str in data.toString().replace(/#.*/g, '').replace(/\n\n/g,'\n').trim().split("[")
      json = for str in data.toString().replace(/\n\n/g,'\n').trim().split("#[[")
        if ! str then continue
        tmp=str.split("]]")
        name=tmp[0]
        config=tmp[1]
        { name: name, config: config }
      cb json

  postTemplate: (conf, cb) ->
    tmplUrl = "#{@hostUrl}/gkm/template/new"
    @readTemplate conf.path, (data) ->
      query = {}
      query.os = conf.os
      query.name = conf.name
      query.configs = data
      console.log query
      command = "curl -b #{@gk3_cookie} -X POST -H 'Content-Type: application/json' -d \'#{JSON.stringify(query)}\' #{tmplUrl}"
      exec command, (err,result) ->
        if result is "ok" then cb true else cb false

  readConfFile: (path, cb) ->
    fs.readFile path, (err, data) ->
      json = for str in data.toString().replace(/\n\n/g,'\n').trim().split("#[[")
        if ! str then continue
        tmp=str.split("]]")
        name=tmp[0]
        config=tmp[1]
        { path: name, content: config }
      cb json

  readService: (name, cb) ->
    data = fs.readdirSync "confs/#{name}-confs", (err, files) ->
      files
    for file in data
      @readConfFile "confs/#{name}-confs/#{file}", (result) -> cb result


  readGroup: (name, cb) ->
    
    @readService "apt-get", (service) ->
      console.log service
    cb true
    

module.exports = new gkmControl


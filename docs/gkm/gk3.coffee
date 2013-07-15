#!/usr/bin/env coffee
exec = require("child_process").exec
_ = require "underscore"

#cookie = "/root/.gk/cookie.cccccccc"
cookie = "gk3.cookie"

hostUrl="http://192.168.56.204:3000"
#hostUrl="https://api-gank.rhcloud.com"
tmpl="#{hostUrl}/gkm/template"
login="#{hostUrl}/signin"

curl="curl -b #{cookie}"
cPost="#{curl} -X POST -H 'Content-Type: application/json'"

#- test get from api
#exec "#{curl} #{tmpl}", (err, stdout, stderr) ->
#  data = JSON.parse stdout
#  modify = _.find data[0].template, (conf) ->
#    conf if conf._id == "5194b1d2aa19018f7900001e"
#  #console.log modify
#  #such as modify one config in template
#  modify.name = "node-js"
#  #console.log modify
#  console.log data[0]

#- login

loginHost = (url) ->
  command="curl -X POST -c #{cookie} -d \"username=gankgu002&password=6116abc\" #{login}"
  exec "#{command}", (err, stdout, stderr) ->
    console.log err if err
    console.log stdout
loginHost()

#- post to api
template_name = "apt-get"

postData = (cnfs) ->
  url="#{tmpl}/#{template_name}/new"
  query={ configs: cnfs }
  console.log JSON.stringify(query)
  command="#{cPost} -d \'#{JSON.stringify(query)}\' \"#{url}\""
  exec "#{command}", (err, stdout, stderr) ->
    console.log stdout

readFile = (cnf) ->
  configs = require "#{cnf}"
  console.log configs
  postData configs
  exec "rm -f #{cnf}.coffee"

exec "mktemp -t gk3.script.XXXXXX.coffee", (err, stdout, stderr) ->
  tmpFile = stdout
  exec "bash txt_to_coffee.sh template/#{template_name} > #{tmpFile}", (err, stdout, stderr) ->
    if err
      console.log err
      process.exit 1
    else
      cnfFile = tmpFile.replace(/.coffee/,'').trim()
      readFile cnfFile

#
postTmpl = (tmpl_name) ->
  url = "#{tmpl}/new"
  query = { name: tmpl_name }
  command="#{cPost} -d \'#{JSON.stringify(query)}\' \"#{url}\""
  exec "#{command}", (err, stdout, stderr) ->
    console.log stdout

#postTmpl template_name
#exec "bash txt_to_coffee.sh template/#{template_name}", (err, stdout, stderr) ->
#  if err
#    console.log err
#    process.exit 1
#  else
#    console.log JSON.parse(stdout)
    #query = { configs: stdout }
    #console.log JSON.stringify(query)
    #postData stdout

#curl gkm/template			[ { name: "", pre-configs: [] }, {} ]
#curl gkm/template/:name		{ name: "", pre-configs: [ {name: "", config: ""}, {}] }
#curl gkm/template/:name/confs		[ { name: "", config: "" }, {} ]

#post
#curl gkm/template/new
#curl gkm/template/:name/new

#put only
#curl gkm/template/:name/confs/:id	{ name: "", config: "" }

#workflow
#1. get 'name pre-configs.name' from gkm/template
#2. get 'name pre-configs' from gkm/template/:tmpl_id

#- update name only
#3. put 'name' to gkm/template/:tmpl_id

#- update one pre-config service once
#4. put 'name' or 'config' to gkm/templates/:tmpl_id/cnfs/:cnf_id

#:
#gkm/#templates/local-dev
#name: local-dev

#name: ngnix
#config: "pkgs=\"\""

#:
#gkm/#templates
#
#name: local-dev; href="local-dev"
#name: apt-get
#name: rvm

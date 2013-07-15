#!/usr/bin/env coffee
exec = require("child_process").exec
_ = require "underscore"

gkConfig= process.env.HOME + "/.gk/config"

hostUrl="http://192.168.56.204:3000"
#hostUrl="https://api-gank.rhcloud.com"
tmpl="#{hostUrl}/gkm/template"
cookie="gk4.cookie"

loginHost = () ->
  login="#{hostUrl}/signin"
  command="curl -X POST -c #{cookie} -d \"username=gankgu002&password=6116abc\" #{login}"
  exec "#{command}", (err, stdout, stderr) ->
    console.log err if err
    console.log stdout

checkLogin = (cb) ->
  url = "#{hostUrl}/ok"
  command = "curl -b #{cookie} #{url}"
  exec command, (err, stdout, stderr) ->
    if stdout is "ok"
      cb true
    else
      cb false
#loginHost()
checkLogin (status) -> process.exit 1 if ! status

# ----
curl="curl -b #{cookie}"
cPost="#{curl} -X POST -H 'Content-Type: application/json'"
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

postTemplate = (template_name) ->
  exec "mktemp -t gk3.script.XXXXXX.coffee", (err, stdout, stderr) ->
    tmpFile = stdout
    command = "bash txt_to_coffee.sh template/#{template_name} > #{tmpFile}"
    exec command, (err, stdout, stderr) ->
      if err
        console.log err
        process.exit 1
      else
        cnfFile = tmpFile.replace(/.coffee/,'').trim()
        readFile cnfFile, template_name

postTmpl = (tmpl_name) ->
  url = "#{tmpl}/new"
  query = { name: tmpl_name }
  command="#{cPost} -d \'#{JSON.stringify(query)}\' \"#{url}\""
  exec "#{command}", (err, stdout, stderr) ->
    console.log stdout

#postTmpl template_name
#postTemplate template_name


required = [
  { name: "nginx", version: "1.4.1", tmplName: "local-dev-ubu-12", cnfsName: "default-config-files" }
  { name: "node", version: "0.10.7", tmplName: "local-dev-ubu-12", cnfsName: "default-config-files" }
]
request =
  targetHost: "api.local.gk.com"
  os: "ubuntu 12.04"
  requestBy: "Jimmy"
  required: required
#console.log request
console.log JSON.stringify(request)

postRequest = (query) ->
  console.log hostUrl
  req_new = "#{hostUrl}/gkm/request/new"
  command = "#{cPost} -d \'#{JSON.stringify(query)}\' \"#{req_new}\""
  exec command, (err, stdout, stderr) ->
    console.log stdout
postRequest request

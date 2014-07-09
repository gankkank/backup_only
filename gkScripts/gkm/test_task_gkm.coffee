#
gkm = require "./tasks/gkm"

gkm.checkLogin (result) ->
  console.log "final: #{result}"

#===============================================================================
#gkm/request
required = [
  { name: "nginx", version: "1.4.1", tmplName: "local-dev-ubu-12", cnfsName: "default-config-files" }
  { name: "node", version: "0.10.7", tmplName: "local-dev-ubu-12", cnfsName: "default-config-files" }
]

request =
  targetHost: "api.local.gk.com"
  os: "ubuntu 12.04"
  requestBy: "Jimmy"
  required: required

#gkm.postRequest request, (result) -> console.log "post: #{result}"


#===============================================================================
#gkm/template
##gkm.readTemplate "./template/apt-get", (result) -> console.log "read tmpl:\n#{JSON.stringify(result)}"
#

config =
  path: "./template/local-dev-ubu-12"
  os: "ubuntu 12.04"
  name: "local-dev-ubu-12"
#gkm.readTemplate "./template/local-dev-ubu-12", (result) -> console.log "read tmpl:\n#{JSON.stringify(result)}"

#config =
#  path: "./template/rvm"
#  os: "ubuntu 12.04"
#  name: "rvm"
#gkm.readTemplate "./template/rvm", (result) -> console.log "read tmpl:\n#{JSON.stringify(result)}"

#gkm.postTemplate config, (result) -> console.log "post tmpl: #{result}"
#
#gkm.readTemplate "./template/apt-get", (result) -> console.log "read tmpl:\n#{JSON.stringify(result)}"
gkm.readGroup "apt-get", (status) -> console.log status

#gkm.readConfFile "confs/apt-get-confs/httpd.main", (status) -> console.log status

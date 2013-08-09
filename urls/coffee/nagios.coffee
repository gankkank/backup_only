
#hostinfo
#hostname use to login server
#hostname, groupname: unique
host1 =
  hostname: "api.c1.rhc.gankkank.com"
  ip: "127.0.0.1"
  description: "api cloud #1"
  services: [ "ssh","mysql","web","ftp","nodejs"]

host2 =
  hostname: "api.c2.rhc.gankkank.com"
  ip: "127.0.0.1"
  description: "api cloud #2"
  services: [ "ssh","mysql","web","ftp","nodejs"]

group =
  groupname: "api"
  description: "api host group"
  hosts: [
    "api.c1.rhc.gankkank.com"
    "api.c2.rhc.gankkank.com"
  ]

createCSV = () ->
  "##{group.groupname},#{group.description}\n
1,#{host1.hostname},#{host1.description},#{host1.hostname},#{host1.services.toString()}"

console.log createCSV()

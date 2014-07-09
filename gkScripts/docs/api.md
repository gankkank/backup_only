API DOC FOR API SERVICES
------------------------

* sources

```bash

home=~
path="http://192.168.56.201:3000/v2"
get="curl -b $home/.gk/gk3.dev.cookie"

$get $path/sources
$get $path/sources?service=nginx&kw=latest
$get $path/sources?service=nginx&kw=latest&op=csv

$get $path/sources/:id
$get $path/sources/:id?op=csv

#kw for keyword
#op for output

#post
post="curl -b $home/.gk/gk3.dev.cookie -X POST -H 'Content-Type: application/json'"
query='{ "service": "nginx", "version": "1.4.0", "url": "http://nginx.org/download/nginx-1.4.0.tar.gz" }'

$post -d "query" $path/sources

#update, delete
$put $path/sources/:id
$del $path/sources/:id

```

* gkm

```bash

#gkm:

$get $path/gkm

#files:

$get $path/gkm/:id/files

#install:

$get $path/gkm/:id/install

```

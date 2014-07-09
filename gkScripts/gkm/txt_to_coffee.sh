#file=template/apt-get
[ -f "$1" ] && file=$1 || exit 1
i=0
m=2
n=`cat $file | grep -v "^#" | grep -v "^$" | wc -l`
cat $file | grep -v "^#" | grep -v "^$" | while read line
do
  service=""
  config=""
  echo $line | grep "^\[" &> /dev/null && service=`echo $line | sed "s/[]\[]//g"` || config="$line"
  if [ "" != "$service" ]
  then
    m=1
    [ $i -eq 0 ] && echo -e "configs = ["
    #[ $i -eq 0 ] && echo -e "["
    [ $i -eq 0  ] || echo -e "  \"\"\"\n  }"
    echo -en "  {\n  name: \"$service\""
  fi
  if [ "" != "$config" ]
  then
    [ $m -eq 1 ] && echo -en ",\n  config: \"\"\""
    let m=m+1
    echo -e "$config"
  fi
  let i=i+1
  [ $i -eq $n ] && [ $m -eq 1 ] && echo -e "\n  }\n]"
  [ $i -eq $n ] && [ $m -ne 1 ] && echo -e "  \"\"\"\n  }\n]"
done
echo "module.exports = configs"

cat &> /dev/null <<EOF
exec = require("child_process").exec
cookie = "/root/.gk/cookie.cccccccc"
curl="curl -b #{cookie}"
cPost="#{curl} -X POST -H 'Content-Type: application/json'"
tmpl="https://api-gank.rhcloud.com/gkm/template"
exec "#{curl} #{tmpl}", (err, stdout, stderr) ->
  console.log stdout
#console.log configs
postData = ->
  url="#{tmpl}/local-dev-ubu-12/new"
  query={ configs: configs  }
  console.log JSON.stringify(query)
  command="#{cPost} -d \'#{JSON.stringify(query)}\' \"#{url}\""
  exec "#{command}", (err, stdout, stderr) ->
    console.log stdout

postTmpl = ->
  url="#{tmpl}/new"
  query={ name: "local-dev-ubu-12"  }
  command="#{cPost} -d \'#{JSON.stringify(query)}\' \"#{url}\""
  exec "#{command}", (err, stdout, stderr) ->
    console.log stdout
postData()
#postTmpl()
EOF

#

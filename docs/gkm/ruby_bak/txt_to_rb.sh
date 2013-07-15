#file=template/apt-get
#waste of time
file=template/local-dev-ubu-12
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
    [ $i -eq 0 ] && echo -e "["
    [ $i -eq 0  ] || echo -e "  ]},"
    echo -en "  {\n  service: \"$service\""
  fi
  if [ "" != "$config" ]
  then
    [ $m -eq 1 ] && echo -en ",\n  config: %q["
    let m=m+1
    echo -e "$config"
  fi
  let i=i+1
  [ $i -eq $n ] && [ $m -eq 1 ] && echo -e "\n  }\n]"
  [ $i -eq $n ] && [ $m -ne 1 ] && echo -e "  ]}\n]"
done

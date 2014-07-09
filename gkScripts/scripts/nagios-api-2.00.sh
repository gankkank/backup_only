#x re-genereate all configuration files
#o use configuration for each host

#implement with: if group name not "Disabled", then cat hosts > /opt/nagios/etc/objects/hosts.cfg

###Part0: Init and Check

apiHost="192.168.1.61:3000/nagios/hosts.csv"
apiServ="192.168.1.61:3000/nagios/services.csv"
apiGroup="192.168.1.61:3000/nagios/groups.csv"

objPath=/opt/nagios/etc/objects
objHostPath=${objPath}/hosts.d
objGroup=/opt/nagios/etc/objects/hostgroup.cfg

check() {
[ ! -d ${odjPath} ] && echo "no ${odjPath}" && mkdir -p ${odjPath}
[ ! -d ${odjHostPath} ] && echo "no ${odjHostPath}" && mkdir -p ${odjHostPath}
}
check

###Part1: Host and Service
genHost() {
#use $objHost
cat >> $objHost << TEMPLATE1
define host{
        use     linux-server,host-pnp
        host_name $hostname
        alias   $aliasname
        address $ipaddress
}
TEMPLATE1
}

genServs() {
#use $services, $tempServ, $objHost
local localIFS=$IFS
IFS=" "
for serv in $services
do
  echo $serv
  dataServ=`grep $serv $tempServ`
  echo $dataServ
  description=`echo $dataServ | cut -d, -f2`
  command=`echo $dataServ | cut -d, -f3`
#
cat >> $objHost << TEMPLATE2
define service{
        use     generic-service,srv-pnp
        host_name       $hostname
        service_description     $description
        check_command   $command
}
TEMPLATE2
done
IFS=$localIFS
}

logicHost() {
#use $apiHost $apiServ $objPath
tempHost=`mktemp -t nagios-host.XXXXXXX`
tempServ=`mktemp -t nagios-serv.XXXXXXX`
curl ${apiHost} 1> $tempHost 2> /dev/null
curl ${apiServ} 1> $tempServ 2> /dev/null
default=$IFS
IFS=$'\n'
for list in `cat $tempHost`
do
  hostname=`echo $list | cut -d, -f1`
  aliasname=`echo $list | cut -d, -f2`
  ipaddress=`echo $list | cut -d, -f3`
  services=`echo $list | cut -d, -f4- | sed "s/,/ /g"`
  objHost=${objHostPath}/${hostname}.cfg
  genHost
  genServs
done
IFS=$default
rm -f $tempHost
rm -f $tempServ
}

###Part2: Group

genGroup() {
#use $objGroup
#append way #2
echo "
define hostgroup{
hostgroup_name $groupname
alias $groupalias
members $members
}" >> $objGroup
}

logicGroup() {
#use $apiGroup
tempGroup=`mktemp -t nagios-group.XXXXXXX`
curl ${apiGroup} 1> $tempGroup 2> /dev/null
default=$IFS
IFS=$'\n'
for list in `cat $tempGroup`
do
  groupname=`echo $list | cut -d, -f1`
  #if [ $groupname = "disabled" ]; then next;fi or just delete the disabled line in $tempGroup
  groupalias=`echo $list | cut -d, -f2`
  members=`echo $list | cut -d, -f3-`
  genGroup
done
IFS=$default
rm -f $tempGroup
}

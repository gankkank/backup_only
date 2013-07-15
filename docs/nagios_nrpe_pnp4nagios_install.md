NAGIOS with nrpe and pnp4nagios install guide [ubuntu]
======================================================

- [x] tested on ubuntu 12.04

## compile install
* packages needed: nagios nrpe pnp4nagios nagios-plugins

* command guide:

#### install nagios

```bash
apt-get install -y libgd2-xpm libpng12-dev libjpeg-dev libgd2-xpm-dev apache2-utils libapr1 libaprutil1 libssl-dev librrds-perl
useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios
usermod -a -G nagcmd apache
./configure --prefix=/opt/nagios --with-command-group=nagcmd --with-nagios-group=nagios
make all
make install-init
make install-config
make install-exfoliation
make install-commandmode
#- for detail of make commands please ref to the information after **make all**
```

info after **make all**

```
  make install
     - This installs the main program, CGIs, and HTML files

  make install-init
     - This installs the init script in /etc/init.d

  make install-commandmode
     - This installs and configures permissions on the
       directory for holding the external command file

  make install-config
     - This installs *SAMPLE* config files in /opt/nagios-3.4.4/etc
       You'll have to modify these sample files before you can
       use Nagios.  Read the HTML documentation for more info
       on doing this.  Pay particular attention to the docs on
       object configuration files, as they determine what/how
       things get monitored!

  make install-webconf
     - This installs the Apache config file for the Nagios
       web interface

  make install-exfoliation
     - This installs the Exfoliation theme for the Nagios
       web interface

  make install-classicui
     - This installs the classic theme for the Nagios
       web interface
```

#### install nrpe nagios-plugins and nrpe-server and pnp4nagios

```bash
#- nagios-plugins
./configure --prefix=/opt/nagios --with-nagios-user=nagios --with-nagios-group=nagios
make
make install

#- nrpe plugin
./configure --prefix=/opt/nagios --with-ssl-lib=/usr/lib/x86_64-linux-gnu
make
make install

#- nrpe server
./configure --prefix=/opt/nrpd --with-ssl-lib=/usr/lib/x86_64-linux-gnu
make
make install

#- pnp4nagios
./configure --prefix=/opt/pnp4nagios
make all
make install
cp contrib/ssi/status-header.ssi /opt/nagios/share/ssi/
```

## configure

#### enable pnp support in nagios
*  edit /opt/nagios/etc/nagios.cfg

```bash
#vi /opt/nagios/etc/nagios.cfg
process_performance_data=1
enable_environment_macros=1
service_perfdata_command=process-service-perfdata
host_perfdata_command=process-host-perfdata
```


*  create template-pnp.cfg in /opt/nagios/etc/objects/

```
define host {
   name       host-pnp
   action_url /pnp4nagios/index.php/graph?host=$HOSTNAME$&srv=_HOST_' class='tips' rel='/pnp4nagios/index.php/popup?host=$HOSTNAME$&srv=_HOST_
   register   0
}

define service {
   name       srv-pnp
   action_url /pnp4nagios/index.php/graph?host=$HOSTNAME$&srv=$SERVICEDESC$' class='tips' rel='/pnp4nagios/index.php/popup?host=$HOSTNAME$&srv=$SERVICEDESC$
   register   0
}
```

*  create commands-pnp.cfg in /opt/nagios/etc/objects/ and delete process-service-perfdata process-host-perfdata  in commands.cfg

```
define command{
        command_name    check_http_self
        command_line    $USER1$/check_http -H '$HOSTADDRESS$' -p '$ARG1$'
}
define command{
        command_name    check_nrpe
command_line    $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}
define command{
        command_name process-service-perfdata
        command_line /opt/pnp4nagios/libexec/process_perfdata.pl
}
define command{
        command_name process-host-perfdata
        command_line /opt/pnp4nagios/libexec/process_perfdata.pl -d HOSTPERFDATA
}
#define command{
#        command_name check_testing_pref
#        command_line /opt/node/bin/coffee /opt/1.coffee
#}

```

*  include cfg files in /opt/nagios/etc/nagios.cfg

```
cfg_file=/opt/nagios/etc/objects/hosts.cfg
cfg_file=/opt/nagios/etc/objects/services.cfg
cfg_file=/opt/nagios/etc/objects/group.cfg
cfg_file=/opt/nagios/etc/objects/commands-pnp.cfg
cfg_file=/opt/nagios/etc/objects/template-pnp.cfg
```

#### create nagios hosts csv file

```
#local,Local Hosts Group
2,localhost,local1,127.0.0.1,ssh,web
```

#### config nrpe

```bash
#- config in /opt/nrpd/etc/nrpe.cfg

log_facility=daemon
pid_file=/var/run/nrpe.pid
server_port=5666
nrpe_user=nagios
nrpe_group=nagios
allowed_hosts=127.0.0.1
dont_blame_nrpe=0
debug=0
command_timeout=60
connection_timeout=300
command[check_users]=/opt/nrpd/libexec/check_users -w 5 -c 10
command[check_load]=/opt/nrpd/libexec/check_load -w 15,10,5 -c 30,25,20
command[check_hda1]=/opt/nrpd/libexec/check_disk -w 20% -c 10% -p /dev/hda1
command[check_zombie_procs]=/opt/nrpd/libexec/check_procs -w 5 -c 10 -s Z
#
command[check_total_procs]=/opt/nrpd/libexec/check_procs -w 700 -c 800 
command[check_raid]=/opt/nrpd/libexec/check_megaraid_sas
command[check_sda1]=/opt/nrpd/libexec/check_disk -w 20% -c 10% -p /dev/sda1
command[check_swap_in]=/opt/nrpd/libexec/check_swap -w 10% -c 5%
command[check_disk]=/opt/nrpd/libexec/check_disk -w 10% -c 5% -r /dev/[shv]d*
command[check_mpt]=/opt/nrpd/libexec/check_mpt.pl -c 2
command[check_mpt2]=sudo sas2ircu-status --nagios
command[check_hp]=/opt/nrpd/libexec/check_hparray -s 1
command[check_disk_lvm]=/opt/nrpd/libexec/check_disk -w 10% -c 5% -r /dev/mapper/mail*
```

#!/bin/bash

set -e

clear

# set colors
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)

echo "       ${green} Snoopy and ${yellow}PRICKLY PETE!"

[[ $quiet ]] && return
echo "${red}"
echo '               _|\ _/|_,'
echo '             ,((\\``-\\\\_'
echo '           ,(())      `))\'
echo '         ,(()))       ,_ \'
echo '        ((())    |        \'
echo '        )))))     >.__     \'
echo '        (((       /   --. .c|'
echo '                 /       --'
echo "${reset}"
echo "${cyan}'All right, we're taking it up a notch!'${reset}"; echo
##################################################################################
#### source variables
echo "${purple}Starting${reset}"
echo "  - variables..."
if [ ! -f 'config.cfg' ]; then
  	echo "$0 needs config.cfg, copy the config.cfg.example to config.cfg, edit it and run again"
fi
. config.cfg

#### run_as runs certain tasks as as $luser (a non-privledged user)
echo "  - runas..."
run_as="sudo -u $luser"

#### tail
if [ "$1" == "tail" ]; then
	multitail --mergeall /opt/prickly-pete/logs/conpot/conpot.log /opt/prickly-pete/logs/cowrie/cowrie.json /opt/prickly-pete/logs/glastopf/glastopf.log /opt/prickly-pete/logs/nepenthes.log /opt/prickly-pete/logs/nepenthes*log
fi

#### running
if [ "$1" == "running" ]; then
	echo "  - are any running..."
	echo "  --------------------"
	ps -fe|grep $luser|grep -v grep
	echo "  --------------------"
	echo "  - are there any pids..."
	find /home/$luser -name "*.pid"
	echo "  --------------------"
	exit 0
fi

#### pids
if [ "$1" == "pids" ]; then
	echo "  - are there any pids..."
	find /home/$luser -name "*.pid"
	echo "  --------------------"
	exit 0
fi

#### stop
if [ "$1" == "stop" ]; then
	echo "  - stop app..."
	if [ -f "/home/$luser/conpot/conpot.pid" ]; then
		echo "    * stop conpot"
		kill `cat /home/$luser/conpot/conpot.pid`
		rm /home/$luser/conpot/conpot.pid
	fi
if [ -f "/home/$luser/cowrie/cowrie.pid" ]; then
	echo "    * stop cowrie"
	#kill `cat /home/$luser/cowrie/*.pid`
	killall twistd
	rm /home/$luser/cowrie/*.pid
fi
if [ -f "/home/$luser/glastopf/glastopf.pid" ]; then
	echo "    * stop glastopf"
	kill `cat /home/$luser/glastopf/*.pid`
	rm /home/$luser/glastopf/*.pid
fi
if [ -f "/home/$luser/honeypot-for-tcp-32764/honeypot-for-tcp-32764.pid" ]; then
	echo "    * stop honeypot-for-tcp-32764"
	forver=$(ps -fe | grep "forever" | head -n1 | awk '{print $2}')
	kill $forever
	if [ -f "/home/$luser/.forever/pids/*.pid" ]; then
		rm /home/$luser/.forever/pids/*.pid
	fi
	sleep 2
	kill `cat /home/$luser/honeypot-for-tcp-32764/*.pid`
	rm /home/$luser/honeypot-for-tcp-32764/*.pid
fi
	echo "  - that should do it, take a look..."
	ps -fe|grep $luser|grep -v grep
	exit 0
fi

#### reset
if [ "$1" == "reset" ]; then
	echo "+ RESET"
	echo "  - kill app(s)..."
	if [ "/home/$luser/*/*.pid" ]; then
		kill `cat /home/$luser/cowrie/*.pid`
		rm /home/$luser/cowrie/*.pid`
		echo -n "  - killing";sleep 1; echo -n".";sleep 1;echo -n ".";sleep 1;echo "."
		cd /home/$luser/honeypot-for-tcp-32764/; npm stop
		rm /home/$luser/honeypot-for-tcp-32764/*.pid`
		echo -n "  - killing";sleep 1; echo -n".";sleep 1;echo -n ".";sleep 1;echo "."
		kill `cat /home/$luser/glastopf/*.pid`
		rm /home/$luser/glastopf/*.pid
		echo -n "  - killing";sleep 1; echo -n".";sleep 1;echo -n ".";sleep 1;echo "."
	else
		echo "  - not running..."
		exit 0
	fi
	echo "  - user..."
	userdel $luser
	echo "  - homedir..."
	rm -rf /home/$luser
	#echo "  - logdir..."
	#rm -rf /opt/$luser
	exit 0
fi

#### developed on Debian Jessie (older/newer versions might work, Ubuntu might work)
echo "  - distro..."
if [ ! -f '/etc/debian_version' ]; then
  echo "$0 must be run on Debian, or a Debian based distro."
  exit 1
fi

#### needs to be run as root (but all apps/services will be run as $luser)
echo "  - root..."
if [[ $UID -ne 0 ]]; then
  echo "$0 must be run as root, but all apps/services will be run as $luser (change variable to change)"
  exit 1
fi

#### dionaea src
if [ ! -f '/etc/apt/sources.list.d/dionaea.list' ]; then
	cp src/dionaea.list /etc/apt/sources.list.d/
	apt-get update
fi

#### install needed software (as listed in src/install.txt file)
echo "  - updates..."
if [ "$soft_update" == "1" ]; then
	if [ ! -f '.updated' ]; then
		apt-get update; apt-get install -yy `cat src/install.txt`
		touch .updated
	fi
	if [ ! -f '/usr/bin/node' ]; then
		ln -s /usr/bin/nodejs /usr/bin/node
	fi
fi

#### add user - if they're not already added
echo "  - user..."
luser_chk=`cat /etc/passwd | grep $luser | wc -l`
if [ ! "$luser_chk" == "1" ]; then
	useradd $luser -m -s /bin/bash 
fi

#### user homedir - set it up if it's not there
echo "  - userhome..."
if [ ! -d '/home/$luser' ]; then
	mkdir -p /home/$luser
	chown $luser:$luser /home/$luser
fi

#### setup persistant log directory owned by $luser
echo "  - logdir..."
log_dir=/opt/prickly-pete/logs
mkdir -p $log_dir
#chown $luser:$luser $log_dir
chown -R $luser:$luser /opt/prickly-pete

##################################################################################
##################################################################################
##################################################################################
echo "${purple}++++++++++++++++++++++++++++++++++++++++${reset}"
hp=cowrie
echo -n "+ $hp - "
echo "an SSH honeypot based on Kippo, logs attacks, shell interaction of the attacker"

if [ ! -d "/home/$luser/$hp/.git" ]; then
echo "  - install"
$run_as bash<<_
cd /home/$luser
git clone https://github.com/micheloosterhof/cowrie.git
_
fi

if [ ! -f "/home/$luser/$hp/$hp.cfg" ]; then
echo "  - config"
cp src/configs/$hp.cfg /home/$luser/$hp
echo "log_path = $log_dir/$hp
[output_jsonlog]
logfile = $log_dir/$hp/$hp.json" >> /home/$luser/$hp/$hp.cfg
chown -R $luser:$luser /home/$luser/$hp
fi

if [ ! -d "$log_dir/$hp" ]; then
	echo "  - logdir"
	mkdir -p $log_dir/$hp
	chown -R $luser:$luser $log_dir/$hp
fi

if [ -f "/home/$luser/$hp/$hp.pid" ]; then
	echo "  - already running as PID `cat /home/$luser/$hp/$hp.pid` "
else

#touch /opt/prickly-pete/logs/cowrie/cowrie.json

echo "  - start"
#touch /home/$luser/cowrie/cowrie.pid
#chown -R $luser:$luser /home/$luser/$hp

$run_as bash<<_
cd /home/$luser/$hp
sh start.sh >> /dev/null
echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1
echo $(ps -fe | grep "$hp" | head -n1 | awk '{print $2}') > $hp.pid
_
echo "  - running as PID `cat /home/$luser/$hp/$hp.pid` "
fi

##################################################################################
##################################################################################
##################################################################################
echo "${purple}++++++++++++++++++++++++++++++++++++++++${reset}"
hp=honeypot-for-tcp-32764
echo -n "+ $hp - "
echo "a router backdoor found in late model consumer router firmwares"
if [ ! -d "/home/$luser/$hp/.git" ]; then
	echo "  - install"
$run_as bash<<_
cd /home/$luser
git clone https://github.com/knalli/honeypot-for-tcp-32764.git
_
fi

if [ ! -d "$log_dir/$hp" ]; then
	echo "  - logdir"
	mkdir -p $log_dir/$hp
	chown $luser:$luser $log_dir/$hp
fi

if [ -f "/home/$luser/$hp/$hp.pid" ]; then
	echo "  - already running as PID `cat /home/$luser/$hp/$hp.pid` "
else
echo "  - start"
$run_as bash<<_
cd /home/$luser/$hp
npm install
npm start
echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1
echo $(ps -fe | grep "$hp" | head -n1 | awk '{print $2}') > $hp.pid
_
echo "  - running as PID `cat /home/$luser/$hp/$hp.pid` "
fi

##################################################################################
##################################################################################
##################################################################################
echo "${purple}++++++++++++++++++++++++++++++++++++++++${reset}"
hp=glastopf
echo -n "+ $hp - "
echo "a web application honeypot"
if [ ! -f "/usr/local/bin/glastopf-runner" ]; then
	echo "  - install"
	pip install --upgrade greenlet
	pip install glastopf
fi

if [ ! -d "/home/$luser/glastopf" ]; then
	echo "  - workdir"
	mkdir /home/$luser/$hp
	cp src/configs/glastopf.cfg /home/$luser/$hp
	echo "logfile = $log_dir/$hp/glastopf.log" >> /home/$luser/$hp/glastopf.cfg

	echo "[webserver]
host = 0.0.0.0
port = 80
proxy_enabled = False
uid = $luser
gid = $luser" >> /home/$luser/$hp/glastopf.cfg

	echo "[main-database]
enabled = True
connection_string = sqlite:///$log_dir/$hp/glastopf.db" >> /home/$luser/$hp/glastopf.cfg

	chown -R $luser:$luser /home/$luser/$hp
fi

if [ ! -d "$log_dir/$hp" ]; then
	echo "  - logdir"
	mkdir -p $log_dir/$hp
	chown $luser:$luser $log_dir/$hp
fi

if [ -f "/home/$luser/$hp/$hp.pid" ]; then
	echo "  - already running as PID `cat /home/$luser/$hp/$hp.pid` "
else
echo "  - start"
#$run_as bash<<_
cd /home/$luser/$hp
python /usr/local/bin/glastopf-runner > /dev/null 2>&1 &
echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1
echo $(ps -fe | grep "$hp" | head -n1 | awk '{print $2}') > /home/$luser/$hp/$hp.pid
chown -R $luser:$luser /home/$luser/$hp/$hp.pid
#_
echo "  - running as PID `cat /home/$luser/$hp/$hp.pid` "
fi

##################################################################################
##################################################################################
##################################################################################
echo "${purple}++++++++++++++++++++++++++++++++++++++++${reset}"
hp=conpot 
echo -n "+ $hp - "
echo "a ICS/SCADA honeypot to collect attacks against industrial control systems"
if [ ! -d "/home/$luser/$hp/.git" ]; then
	echo "  - install"
	easy_install -U setuptools
	pip install conpot
$run_as bash<<_
cd /home/$luser
git clone https://github.com/mushorg/conpot.git
cp src/configs/conpot.cfg /home/$luser/$hp
_
fi

#cp src/configs/conpot.cfg /home/$luser/$hp
echo "[daemon]
user = $luser
group = $luser" >> /home/$luser/$hp/$hp.cfg
chown -R $luser:$luser /home/$luser/$hp

if [ ! -d "$log_dir/$hp" ]; then
	echo "  - logdir"
	mkdir -p $log_dir/$hp
	chown $luser:$luser $log_dir/$hp
fi

if [ -f "/home/$luser/$hp/$hp.pid" ]; then
	echo "  - already running as PID `cat /home/$luser/$hp/$hp.pid` "
else
echo "  - start"
nohup conpot --config /home/$luser/$hp/$hp.cfg --logfile $log_dir/$hp/$hp.log --template kamstrup_382 &
echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1
echo $(ps -fe | grep "$hp" | head -n1 | awk '{print $2}') > /home/$luser/$hp/$hp.pid
chown -R $luser:$luser /home/$luser/$hp/$hp.pid
echo "  - running as PID `cat /home/$luser/$hp/$hp.pid` "
fi
echo "${purple}++++++++++++++++++++++++++++++++++++++++${reset}"

##################################################################################
##################################################################################
##################################################################################
hp=nepenthes
echo -n "+ $hp - "
echo "by emulating widespread vulns this catches and stores viruses worms using these vulns"  
if [ ! -f "/usr/sbin/nepenthes" ]; then
	echo "  - install"
	wget http://debian.fastweb.it/debian/pool/main/n/nepenthes/nepenthes_0.2.2-6_i386.deb
	dpkg -i nepenthes_0.2.2-6_i386.deb
	rm nepenthes_0.2.2-6_i386.deb
fi
if [ ! -d "/home/$luser/$hp" ]; then
	echo "  - workdir"
	mkdir -p /home/$luser/$hp
fi
if [ ! -f "/home/$luser/$hp/$hp.conf" ]; then
	echo "  - config"
	cp src/configs/$hp.conf /home/$luser/$hp
#	echo "submitmanager
#    {
#        strictfiletype              "1";
#        // where does submit-file write to? set this to the same dir
#        filesdir                    "$log_dir/$hp/binaries/";
#    };
#    };" >> /home/$luser/$hp/$hp.conf
sed -i "s/var\/log/opt\/prickly\-pete\/logs/" /home/kennyg/nepenthes/nepenthes.conf
sed -i "s/var\/lib/opt\/prickly\-pete\/logs/" /home/kennyg/nepenthes/nepenthes.conf
chown -R $luser:$luser /home/$luser/$hp
fi

if [ ! -d "$log_dir/$hp" ]; then
	echo "  - logdir"
	mkdir -p $log_dir/$hp
	mkdir -p $log_dir/$hp/binaries
	mkdir -p $log_dir/$hp/hexdumps
	chown -R $luser:$luser $log_dir/$hp
fi

if [ -f "/home/$luser/$hp/$hp.pid" ]; then
	echo "  - already running as PID `cat /home/$luser/$hp/$hp.pid` "
else
echo "  - start"
nepenthes -c /home/$luser/$hp/$hp.conf -u $luser -g $luser -D > /dev/null
#nepenthes -c /home/$luser/$hp/$hp.conf -u $luser -g $luser

echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1
echo $(ps -fe | grep "$hp" | head -n1 | awk '{print $2}') > /home/$luser/$hp/$hp.pid
chown -R $luser:$luser /home/$luser/$hp/$hp.pid
echo "  - running as PID `cat /home/$luser/$hp/$hp.pid` "
fi

echo "${purple}++++++++++++++++++++++++++++++++++++++++${reset}"
exit 0



#### block template to add new honeypots (add name to hp, finish all ???)
##################################################################################
##################################################################################
##################################################################################
hp=
echo -n "+ $hp - "
echo "??? description here"
if [ ! -d "/home/$luser/$hp/.git" ]; then
	echo "  - install"
$run_as bash<<_
cd /home/$luser
git clone ???
_
fi

echo "  - logdir"
if [ ! -d "$log_dir/$hp" ]; then
	mkdir $log_dir/$hp
	chown $luser:$luser $log_dir/$hp
fi

echo "  - start"
$run_as bash<<_
cd /home/$luser/$hp
???
_

echo "  - running as PID `cat /home/$luser/$hp/$hp.pid` "
##################################################################################
exit 0
mkdir -p /opt/prickly-pete/logs/dionaea/bistreams
mkdir -p /opt/prickly-pete/logs/dionaea/wwwroot
mkdir -p /opt/prickly-pete/logs/dionaea/binaries
mkdir -p /opt/prickly-pete/logs/dionaea/
chown -R kennyg:kennyg /opt/prickly-pete/logs/dionaea/ /home/kennyg/dionaea

chown -R nobody:nogroup /opt/prickly-pete/logs/dionaea/

#dionaea -c my.conf -u kennyg -g kennyg -w /home/kennyg/dionaea -l all,-debug -L '*'

dionaea -c /home/phil/devel/prickly-pete/my.conf -u nobody -g nogroup -w /opt/prickly-pete/logs/dionaea -p /var/run/dionaea.pid -l all,-debug -L '*'

#!/bin/bash

set -e

echo "* $0"
##################################################################################
#### source variables
echo "  - variables..."
if [ ! -f 'config.cfg' ]; then
  	echo "$0 needs config.cfg, copy the config.cfg.example to config.cfg, edit it and run again"
fi
. config.cfg

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
	echo "  - logdir..."
	rm -rf /opt/$luser
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
log_dir=/opt/$luser/logs
mkdir -p $log_dir
chown $luser:$luser $log_dir

#### run_as runs certain tasks as as $luser (a non-privledged user)
echo "  - runas..."
run_as="sudo -u $luser"

##################################################################################
echo "++++++++++++++++++++++++++++++"
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

echo "  - config"
cp src/configs/$hp.cfg /home/$luser/$hp
echo "log_path = $log_dir/$hp
[output_jsonlog]
logfile = $log_dir/$hp/$hp.json" >> /home/$luser/$hp/$hp.cfg
chown -R $luser:$luser /home/$luser/$hp

echo "  - logdir"
if [ ! -d "$log_dir/$hp" ]; then
	mkdir $log_dir/$hp
	chown $luser:$luser $log_dir/$hp
fi

echo "  - start"
if [ -f "/home/$luser/$hp/$hp.pid" ]; then
	echo "  - already running as PID `cat /home/$luser/$hp/$hp.pid` "
else
$run_as bash<<_
cd /home/$luser/$hp
sh start.sh >> /dev/null
echo "  - running as PID `cat /home/$luser/$hp/$hp.pid` "
_
fi

##################################################################################
echo "++++++++++++++++++++++++++++++"
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

echo "  - logdir"
if [ ! -d "$log_dir/$hp" ]; then
	mkdir $log_dir/$hp
	chown $luser:$luser $log_dir/$hp
fi

echo "  - start"
if [ -f "/home/$luser/$hp/$hp.pid" ]; then
	echo "  - already running as PID `cat /home/$luser/$hp/$hp.pid` "
else
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
echo "++++++++++++++++++++++++++++++"
hp=glastopf
echo -n "+ $hp - "
echo "a web application honeypot"
echo "  - install"
if [ ! -f "/usr/local/bin/glastopf-runner" ]; then
	pip install --upgrade greenlet
	pip install glastopf
fi

echo "  - workdir"
if [ ! -d "/home/$luser/glastopf" ]; then
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

echo "  - logdir"
if [ ! -d "$log_dir/$hp" ]; then
	mkdir $log_dir/$hp
	chown $luser:$luser $log_dir/$hp
fi

echo "  - start"
if [ -f "/home/$luser/$hp/$hp.pid" ]; then
	echo "  - already running as PID `cat /home/$luser/$hp/$hp.pid` "
else
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
echo "++++++++++++++++++++++++++++++"
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
_
fi

cp src/configs/conpot.cfg /home/$luser/$hp
echo "[daemon]
user = $luser
group = $luser" >> /home/$luser/$hp/$hp.cfg
chown -R $luser:$luser /home/$luser/$hp

echo "  - logdir"
if [ ! -d "$log_dir/$hp" ]; then
	mkdir $log_dir/$hp
	chown $luser:$luser $log_dir/$hp
fi

echo "  - start"
if [ -f "/home/$luser/$hp/$hp.pid" ]; then
	echo "  - already running as PID `cat /home/$luser/$hp/$hp.pid` "
else
nohup conpot --config /home/$luser/$hp/$hp.cfg --logfile $log_dir/$hp/$hp.log --template kamstrup_382 &
sleep 2
echo $(ps -fe | grep "$hp" | head -n1 | awk '{print $2}') > /home/$luser/$hp/$hp.pid
chown -R $luser:$luser /home/$luser/$hp/$hp.pid
echo "  - running as PID `cat /home/$luser/$hp/$hp.pid` "
fi

##################################################################################
exit 0



screen -S conpot -d -m conpot --config /home/ken/conpot/conpot.cfg --logfile /opt/ken/logs/conpot/conpot.log --template kamstrup_382






#### block template to add new honeypots (add name to hp, finish all ???)
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

# prickly-pete
<div align="center"><img src="logo.png" alt="Prickly Pete">
&nbsp;+&nbsp;<img src="https://store.eventcapture.com/cdn/shop/files/DC33-web_logo_2400x.jpg" height="287" width="300"></div>

**UPDATE** Prickly-Pete has been fully updated for 2025 (DEF CON 33). Some of the **amazing** improvements include:

* newer honeypot containers, with updated code and builds 
* more ports now exposed by default (**23** at last count)
* ability to pre-build containers so they're ready to run when needed (`./pp build`)
* logs and all output collected as docker volumes now, output shows you were the files/directories are saved to (`./pp volumes`)
* however, DEF CON is still canceled 

## Overview 
Prickly-Pete is a script that uses [Docker](https://www.docker.com) to quickly bring up some honeypots exposing a bunch of services. For research, reconnaissance and fun. While originally built to run on a laptop during the [DEF CON](https://defcon.org/) hacker conference to see how many pings and pokes we could attract, it's a useful tool for research, and reconnaissance to test networks for infestations. Using Docker and [Docker-Compose](https://docs.docker.com/compose/) to containerize all the honeypot services greatly speeding up deployment time while reducing system requirements. 

## Security?
While this project is designed to help identify security issues, and was culled from others who likely have security in mind, I would NOT recommend running this in production environment without a complete security audit... but then again, YOLO!

## Honeypots
prickly-pete uses Docker and Docker-Compose to bring up the following honeypots, automatically, with no configuration or extra steps necessary.

### Existing
* [Conpot](https://github.com/mushorg/conpot.git) - an ICS honeypot with the goal to collect intelligence about the motives and methods of adversaries targeting industrial control systems
* [Cowrie](https://github.com/cowrie/cowrie.git) - an SSH/Telnet honeypot, originally based on Kippo
* [Heralding](https://github.com/johnnykv/heralding.git) - a simple honeypot that collects credentials, currently supporting: ftp, telnet, ssh, http, https, pop3, pop3s, imap, imaps, smtp, vnc, postgresql and socks5.
* [Honeyaml](https://github.com/mmta/honeyaml) - an API honeypot whose endpoints and responses are all configurable through a YAML file, supports JWT-based HTTP bearer/token authentication, and logs all accesses into a file in JSON lines format

## Requirements

Prickly-Pete will run on any 64-bit computer that has `git`, `Docker`, and `Docker-Compose` installed and running. I've developed this in Linux, so it's been fully tested in Debian, Ubuntu, RHEL, and CentOS. I'd expect it to work pefectly under Mac OSX too, and while I haven't tried in Windows *"it should work"* since it all runs in Docker with no modifications. Give it a try and let me know if it works for you, pull requests welcome!

## Usage

* Install [Docker](https://docs.docker.com/engine/installation/)
* Install [Docker-Compose](https://docs.docker.com/compose/install/)
* Checkout `prickly-pete` and change into the directory

```
git clone https://github.com/philcryer/prickly-pete.git && cd prickly-pete
```

* Build

Build all the honeypot services

```
./pp build
```

* Up

Up starts all the honeypot services (implies `build`)

```
./pp up
```

* Status

Check the status of the services (normal `docker ps` stuff here)

```
./pp status
____________
| ___ \ ___ |   Prickly
| |_/ / |_/ /   e
|  __/|  __/    t     - honeypots, running in docker
| |   | |       e     - created in 2019, updated Summer 2025
\_|   \_|

[01;33m[*][0m status: running containers and their ports
NAME                       IMAGE                    COMMAND                  SERVICE     CREATED          STATUS          PORTS
prickly-pete-conpot-1      prickly-pete-conpot      "conpot --template d…"   conpot      12 minutes ago   Up 12 minutes   0.0.0.0:44818->44818/tcp, [::]:44818->44818/tcp, 0.0.0.0:47808->47808/udp, [::]:47808->47808/udp, 0.0.0.0:21->2121/tcp, [::]:21->2121/tcp, 0.0.0.0:502->5020/tcp, [::]:502->5020/tcp, 0.0.0.0:623->6230/udp, [::]:623->6230/udp, 0.0.0.0:69->6969/udp, [::]:69->6969/udp, 0.0.0.0:80->8800/tcp, [::]:80->8800/tcp, 0.0.0.0:102->10201/tcp, [::]:102->10201/tcp, 0.0.0.0:161->16100/udp, [::]:161->16100/udp
prickly-pete-cowrie-1      cowrie/cowrie            "/cowrie/cowrie-env/…"   cowrie      56 minutes ago   Up 12 minutes   0.0.0.0:22->2222/tcp, [::]:22->2222/tcp, 0.0.0.0:23->2223/tcp, [::]:23->2223/tcp
prickly-pete-heralding-1   prickly-pete-heralding   "heralding"              heralding   12 minutes ago   Up 12 minutes   21-23/tcp, 0.0.0.0:25->25/tcp, [::]:25->25/tcp, 0.0.0.0:110->110/tcp, [::]:110->110/tcp, 0.0.0.0:143->143/tcp, [::]:143->143/tcp, 0.0.0.0:443->443/tcp, [::]:443->443/tcp, 0.0.0.0:465->465/tcp, [::]:465->465/tcp, 0.0.0.0:993->993/tcp, [::]:993->993/tcp, 0.0.0.0:995->995/tcp, [::]:995->995/tcp, 0.0.0.0:1080->1080/tcp, [::]:1080->1080/tcp, 0.0.0.0:2222->2222/tcp, [::]:2222->2222/tcp, 0.0.0.0:3306->3306/tcp, [::]:3306->3306/tcp, 0.0.0.0:3389->3389/tcp, [::]:3389->3389/tcp, 0.0.0.0:5432->5432/tcp, [::]:5432->5432/tcp, 80/tcp, 0.0.0.0:5900->5900/tcp, [::]:5900->5900/tcp

[01;33m[*][0m volumes: all container volumes holding logs and output data
VOLUME NAME - MOUNTPOINT
prickly-pete_ppv-conpot-var - /var/lib/docker/volumes/prickly-pete_ppv-conpot-var/_data
prickly-pete_ppv-cowrie-etc - /var/lib/docker/volumes/prickly-pete_ppv-cowrie-etc/_data
prickly-pete_ppv-cowrie-var - /var/lib/docker/volumes/prickly-pete_ppv-cowrie-var/_data
prickly-pete_ppv-heralding-var - /var/lib/docker/volumes/prickly-pete_ppv-heralding-var/_data
```

* Scan

Use nmap to scan open ports in `pp`

```
❯ ./pp scan
____________
| ___ \ ___ |   Prickly
| |_/ / |_/ /   e
|  __/|  __/    t     - honeypots, running in docker
| |   | |       e     - created in 2019, updated Summer 2025
\_|   \_|

[*] scan: scanning local ports via nmap (nmap -p- localhost)
Starting Nmap 7.97 ( https://nmap.org ) at 2025-08-06 20:24 +0000
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00018s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 65514 closed tcp ports (conn-refused)
PORT      STATE SERVICE
21/tcp    open  ftp
22/tcp    open  ssh
23/tcp    open  telnet
25/tcp    open  smtp
80/tcp    open  http
102/tcp   open  iso-tsap
110/tcp   open  pop3
143/tcp   open  imap
443/tcp   open  https
465/tcp   open  smtps
502/tcp   open  mbap
993/tcp   open  imaps
995/tcp   open  pop3s
1080/tcp  open  socks
2222/tcp  open  EtherNetIP-1
3306/tcp  open  mysql
3389/tcp  open  ms-wbt-server
5432/tcp  open  postgresql
5900/tcp  open  vnc
6666/tcp  open  irc
44818/tcp open  EtherNetIP-2

Nmap done: 1 IP address (1 host up) scanned in 3.49 seconds
```

* Logs

Tail all the logs in realtime

```
./prickly-pete logs
```

* Stop

Stop all services

```
./prickly-pete stop
```

### Output

All logs, and any downloaded malware or other bits, can be found in the docker volumes. To see the locations of the files:

```
./pp volumes
```
These will persist after the process ends, and subsquent runs will add to those same volumes. To clear them:

```
./pp nuke
```


### Issues

* If you get any errors when you're first running prickly-pete, they'll likely look something like this:

```
ERROR: for pricklypete_conpot_1  Cannot start service conpot: driver failed programming external connectivity on endpoint pricklypete_conpot_1 (cc7d3b484bcf24a08b63792c5188deddb19fd9809eaf35df15fa92ac024e4a99): Error starting userland proxy: listen udp 0.0.0.0:161: bind: address already in use
```

Errors like this means that the port (in this case 161) is already taken, and something, in this case SNMP, is listening on the port. To fix this just open `docker-compose.yml` in a text editor, comment out the offending port, and try to use one of the alternative ones I have listed by uncommenting them. I have options for 22, 80, 161 since those tend to be the ones that are running, but for more fun, turn off those services on your localhost and let prickly-pete use them for the time being!

* Another issue could be that you're running a firewall blocking access to ports, you'll want to stop or turn off any firewalls on the host that you're running prickly-pete on so that everything gets through! Another idea if you're inside a network (like at home) set your router to forward all traffic to a [DMZ](https://en.wikipedia.org/wiki/DMZ_(computing)), and then set that DMZ to be the IP of the host running prickly-pete, this is an easy way to begin to understand all the *noise* that is contantly being broadcast on the internet, and why an active defense is neccessary.

* If you're having issues outside of these basic things, feel free to open an [issue](https://github.com/philcryer/prickly-pete/issues), or ping me on Twitter where I'm [@fak3r](https://twitter.com/fak3r).

* Of course if you've fixed something yourself, or have an improvement you'd like to suggest, [pull requests](https://github.com/philcryer/prickly-pete/pulls) are always welcome!

## Testing

Once up, see what you can see using various system tools, which should be installed on most Unix-like systems.

* ssh

```
ssh localhost -p 22 -l root
```

Passord: `toor`

* nmap

```
$ sudo nmap -p- localhost

Starting Nmap 7.97 ( https://nmap.org ) at 2025-08-06 18:34 +0000
Nmap scan report for hi.lowf.at (66.42.81.17)
Host is up (0.00028s latency).
rDNS record for 66.42.81.17: 66.42.81.17.vultrusercontent.com
Not shown: 65515 closed tcp ports (conn-refused)
PORT      STATE SERVICE
21/tcp    open  ftp
22/tcp    open  ssh
23/tcp    open  telnet
25/tcp    open  smtp
80/tcp    open  http
102/tcp   open  iso-tsap
110/tcp   open  pop3
143/tcp   open  imap
443/tcp   open  https
465/tcp   open  smtps
502/tcp   open  mbap
993/tcp   open  imaps
995/tcp   open  pop3s
1080/tcp  open  socks
3306/tcp  open  mysql
3389/tcp  open  ms-wbt-server
5432/tcp  open  postgresql
5900/tcp  open  vnc
6666/tcp  open  irc
44818/tcp open  EtherNetIP-2

Nmap done: 1 IP address (1 host up) scanned in 4.42 seconds
```

* curl

```
curl localhost:80
```

* curl (API)

```
curl 'localhost:8080/auth' -s -XPOST -d'{ "username": "admin", "password": "admpasswd", "realm": "asgard" }'
```

* netstat

```
sudo netstat -plunt | grep docker
```

## License

* prickly-pete is open source, via the permissive [MIT License](https://github.com/philcryer/prickly-pete/blob/master/LICENSE)

## Acknowledgements

Software, existing projects, and ideas that I used to create this project

* [Docker](https://docker.com/), [Docker-Compose](https://docker.com/compose), and [Docker Hub](https://hub.docker.com/) for prebuilt images
* [Alpine Linux](https://alpinelinux.org/), a small Linux base image for Docker images that you should use if you're building your own
* [mushorg/conpot](https://github.com/mushorg/conpot), a ICS/SCADA honeypot 
* [cowrie](https://github.com/cowrie/docker-cowrie) an SSH/Telnet honeypot
* [dionaea](https://github.com/DinoTools/dionaea) the dionaea honeypot
* [HoneyPress](https://hub.docker.com/r/jondkelley/honeypress) a WordPress honeypot
* [gate](https://hub.docker.com/r/anfa/gate) NodeJS webserver and honeypot
* [udpot](https://hub.docker.com/r/jekil/udpot) a DNS honeypot 

Older bits that are now legacy, but got us to where we are now

* [andrewmichaelsmith/manuka](https://github.com/andrewmichaelsmith/manuka), Docker based honeypot (Dionaea & Kippo)
* [DinoTools/dionaea-docker](https://github.com/DinoTools/dionaea-docker), Dionaea running in Docker
* [kost/docker-cowrie](https://github.com/kost/docker-cowrie), a version of Cowrie running in Docker
* [glastopf](https://github.com/mushorg/glastopf) - Glastopf is a Python web application honeypot founded by Lukas Rist.
* [honeypot-for-tcp-32764](https://github.com/knalli/honeypot-for-tcp-32764) - a first try to mock the router backdoor "TCP32764" found in several router firmwares at the end of 2013. The POC of the backdoor is included with the project.
* [nepenthes](http://nepenthes.carnivore.it/)- a honeypot that works by emulating widespread vulns and then catches and stores viruses worms using these vulns (working to implement [Dionaea](http://dionaea.carnivore.it/) to take its place)"
* [dionaea](https://github.com/DinoTools/dionaea), the dionaea honeypot, using the official DockerHub image [dinotools/dionaea](https://hub.docker.com/r/dinotools/dionaea)
* [HoneyPress](https://hub.docker.com/r/jondkelley/honeypress), a WordPress honeypot using the DockerHub image from [jondkelley/honeypress](https://hub.docker.com/r/jondkelley/honeypress)
* [gate](https://hub.docker.com/r/anfa/gate), NodeJS webserver and honeypot running on :3000 with a fake index.html copied from nodejs.org (you can create your own and put it in src/gate/ to have it use that instead) TODO: get logging working
* [udpot](https://hub.docker.com/r/jekil/udpot) a DNS honeypot which logs all requests to a SQLite database
* [Ciscoasa_honeypot](https://github.com/Cymmetria/ciscoasa_honeypot.git) - a low interaction honeypot for the Cisco ASA component capable of detecting CVE-2018-0101, a DoS and remote code execution vulnerability

### Thanks

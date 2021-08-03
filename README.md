# prickly-pete

**UPDATE** updated for DEF CON 29, 2021! Now using the offical version of cowrie, and dionaea! There are more services now by default, new config/options, same out of the box goodness if you just want to try it out to get your feet wet! Ping me with any questions.

A script using [Docker](https://www.docker.com) to quickly bring up some honeypots exposing over 16 services. For research, reconnaissance and fun. While originally built to run on a laptop during the [DEF CON](https://defcon.org/) hacker conference to see how many pings and pokes we could attract, it's a useful tool for research, and reconnaissance to test networks for infestations. I've completely rewritten this (July 2017) to use Docker and [Docker-Compose](https://docs.docker.com/compose/) to containerize all the honeypot services, greatly speeding up deployment time while reducing system requirements. 

### Security?
While this project is designed to help identify security issues, and was culled from others who likely have security in mind, I would NOT recommend running this in production environment without a complete security audit... but then again, YOLO!

## Honeypots
prickly-pete uses Docker and Docker-Compose to bring up the following honeypots, automatically, with no configuration or extra steps necessary.

* [contpot](https://pypi.python.org/pypi/Conpot) - an ICS honeypot with the goal to collect intelligence about the motives and methods of adversaries targeting industrial control systems
* [cowrie](https://github.com/cowrie/docker-cowrie) - an SSH/Telnet honeypot, originally based on Kippo, using the official DockerHub image [cowrie/cowrie](https://hub.docker.com/r/cowrie/cowrie)
* [dionaea](https://github.com/DinoTools/dionaea), the dionaea honeypot, using the official DockerHub image [dinotools/dionaea]https://hub.docker.com/r/dinotools/dionaea)
* [gate](https://hub.docker.com/r/anfa/gate), NodeJS webserver and honeypot running on :3000 with a fake index.html copied from nodejs.org (you can create your own and put it in src/gate/ to have it use that instead) TODO: get logging working
* [udpot](https://hub.docker.com/r/jekil/udpot) a DNS honeypot which logs all requests to a SQLite database

## Requirements

Prickly-Pete will run on any 64-bit computer that has `git`, `Docker`, and `Docker-Compose` installed and running. I've developed this in Linux, so it's been fully tested in Debian, Ubuntu, RHEL, and CentOS. I'd expect it to work pefectly under Mac OSX too, and while I haven't tried in Windows *"it should work"* since it all runs in Docker with no modifications. Give it a try and let me know if it works for you, pull requests welcome!

## Usage

* Install [Docker](https://docs.docker.com/engine/installation/)
* Install [Docker-Compose](https://docs.docker.com/compose/install/)
* Checkout `prickly-pete` and change into the directory

```
git clone https://github.com/philcryer/prickly-pete.git && cd prickly-pete
```

* Start

```
./prickly-pete start
```

* Status

```
./prickly-pete status
```

* Log

```
./prickly-pete log
```

* Stopping

```
./prickly-pete stop
```

### Output

All logs, and any downloaded malware or other bits, can be found in script created `var` directory, which will persist after the process ends. Note that restarting the script will use the same directories and will include all new logs/downloads. 

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
ssh localhost -p 2222 -l root
```

* nmap

```
$ sudo nmap -p- localhost

Starting Nmap 7.91 ( https://nmap.org ) at 2021-08-03 17:51 CDT
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00028s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 65518 closed ports
PORT      STATE    SERVICE
21/tcp    open     ftp
102/tcp   open     iso-tsap
502/tcp   open     mbap
623/tcp   open     oob-ws-http
2222/tcp  open     EtherNetIP-1
3000/tcp  open     ppp
8080/tcp  open     http-proxy
8888/tcp  open     sun-answerbook
44818/tcp open     EtherNetIP-2
47808/tcp open     bacnet
49288/tcp open     unknown
51413/tcp open     unknown
55650/tcp open     unknown
57621/tcp open     unknown
57622/tcp open     unknown
61500/tcp filtered unknown
63334/tcp filtered unknown

Nmap done: 1 IP address (1 host up) scanned in 5.94 seconds
```

* curl

```
curl localhost:443
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
* [andrewmichaelsmith/manuka](https://github.com/andrewmichaelsmith/manuka), Docker based honeypot (Dionaea & Kippo)
* [mushorg/conpot](https://github.com/mushorg/conpot), a ICS/SCADA honeypot 
* [DinoTools/dionaea-docker](https://github.com/DinoTools/dionaea-docker), Dionaea running in Docker
* [kost/docker-cowrie](https://github.com/kost/docker-cowrie), a version of Cowrie running in Docker

Older bits that are now legacy, but got us to where we are now

* [glastopf](https://github.com/mushorg/glastopf) - Glastopf is a Python web application honeypot founded by Lukas Rist.
* [honeypot-for-tcp-32764](https://github.com/knalli/honeypot-for-tcp-32764) - a first try to mock the router backdoor "TCP32764" found in several router firmwares at the end of 2013. The POC of the backdoor is included with the project.
* [nepenthes](http://nepenthes.carnivore.it/)- a honeypot that works by emulating widespread vulns and then catches and stores viruses worms using these vulns (working to implement [Dionaea](http://dionaea.carnivore.it/) to take its place)"

## Prickly-Pete?

__George,__ _driving in the car with the Rosses:_ "And that leads into the master bedroom."

__Mrs. Ross:__ "Tell us more."

__George:__ "You want to hear more? The master bedroom opens into the solarium."

__Mr. Ross:__ "Another solarium?"

__George:__ "Yes, two solariums. Quite a find. And I have horses, too."

![](src/imgs/snoopy_and_prickly_pete.jpg)

__Mr. Ross:__ "What are their names?"

__George:__ "Snoopy and Prickly Pete. Should I keep driving?"

__Mrs. Ross:__ "Oh, look, an antique stand. Pull over. We'll buy you a 
housewarming gift."

__George,__ _chuckling to himself:_ "Housewarming gift."

__George,__ _swerving the car to go to the antique stand:_ "All right, we're taking
it up a notch!"

# prickly-pete
A script using Docker (and Docker-Compose) to quickly bring up some honeypots exposing 19 services. For research, reconnaissance and fun. While originally built to run on a laptop during DEF CON conference to see how many pings and pokes we could attract, it should be useful for research, and reconnaissance to test networks for infestations. Complete rewritten in 2017 to use [Docker](https://www.docker.com/) and [Docker-Compose](https://docs.docker.com/compose/) to containerize all honeypot services, greatly speeding up deployment time while reducing system requirements. 

### Security?
While this project is designed to help identify security issues, and was culled from others who likely have security in mind, I would NOT recommend running this in production environment without a complete security audit... but then again, YOLO!

## Honeypots

prickly-pete uses Docker and Docker-Compose to bring up the following honeypots, automatically, with no configuration or extra steps necessary.


* [contpot](https://pypi.python.org/pypi/Conpot) - an ICS honeypot with the goal to collect intelligence about the motives and methods of adversaries targeting industrial control systems
* [cowrie](https://github.com/micheloosterhof/cowrie) - SSH/Telnet honeypot, originally based on Kippo, using the DockerHub image [k0st/cowrie](https://hub.docker.com/r/k0st/cowrie/)]
* [dionaea](https://github.com/DinoTools/dionaea), the dionaea honeypot,  using the DockerHub image [andrewmichaelsmith/dionaea](https://hub.docker.com/r/andrewmichaelsmith/dionaea/)

## Usage

* Install [Docker](https://docs.docker.com/engine/installation/)
* Install [Docker-Compose](https://docs.docker.com/compose/install/)
* Checkout `prickly-pete` and change into the directory

```
git clone https://github.com/philcryer/prickly-pete.git && cd prickly-pete
```

* Runing

```
./prickly-pete start
```

* Status

```
./prickly-pete status
```

* Logging

```
tail -f var/cowrie/log/cowrie.* var/dionaea/log/dionaea* var/conpot/conpot.log
```
	
* Stopping

```
./prickly-pete stop
```

### Errors

If you get any errors when you're first running prickly-pete, they'll likely look something like this:

```
ERROR: for pricklypete_conpot_1  Cannot start service conpot: driver failed programming external connectivity on endpoint pricklypete_conpot_1 (cc7d3b484bcf24a08b63792c5188deddb19fd9809eaf35df15fa92ac024e4a99): Error starting userland proxy: listen udp 0.0.0.0:161: bind: address already in use
```

It just means that the port (in this case 161) is already taken, and something, in this case SNMPD, is listening on the port. To fix, just open `docker-compose.yml` in a text editor, comment out the offending line, and try to use one of the alternative ones I have listed by uncommenting them. I have options for 22, 80, 161 since those tend to be the ones that are running, but for more fun, turn off those services on your localhost and let prickly-pete use them for the time being!

## Testing

Once up, see what you can see using various system tools

* `nmap`

```
$ nmap localhost

Starting Nmap 6.40 ( http://nmap.org ) at 2017-07-11 13:10 CDT
Nmap scan report for localhost (127.0.0.1)
Host is up (0.0016s latency).
Other addresses for localhost (not scanned): 127.0.0.1
Not shown: 983 closed ports
PORT     STATE SERVICE
21/tcp   open  ftp
22/tcp   open  ssh
42/tcp   open  nameserver
135/tcp  open  msrpc
443/tcp  open  https
445/tcp  open  microsoft-ds
1433/tcp open  ms-sql-s
2222/tcp open  EtherNet/IP-1
3306/tcp open  mysql
5060/tcp open  sip
5061/tcp open  sip-tls
8080/tcp open  http-proxy
```

* `ssh`

```
ssh localhost -p 2222 -l root
```

* `curl`

```
curl localhost:443
```


* contpot - ssh to the port (note that the MAC address can be changed in the config for further confusion)

```
$ curl localhost:50100
Welcome...
Connected to [00:13:EA:00:00:00]

? Command not found.
Send 'H' for help.
```

* netstat

```
netstat -plunt | grep docker
```

## License

[MIT License](https://tldrlegal.com/license/mit-license)

## Acknowledgements

Software, existing projects, and ideas that I used to create this project

* [Docker](https://docker.com/), [Docker-Compose](https://docker.com/compose), and [Docker Hub](https://hub.docker.com/) for prebuilt images
* [Alpine Linux](https://alpinelinux.org/), a small Linux base image for Docker images that you should use if you're building your own
* [andrewmichaelsmith/manuka](https://github.com/andrewmichaelsmith/manuka), Docker based honeypot (Dionaea & Kippo)
* [mushorg/conpot](https://github.com/mushorg/conpot), a ICS/SCADA honeypot 
* [dionaea-docker](https://github.com/DinoTools/dionaea-docker)
* [github](https://github.com/kost/docker-cowrie)

Older bits that are now legacy, but got us to where we are not

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

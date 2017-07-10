# prickly-pete
A setup script to bring up a box laden with various honeypots running as many exposed services as possible. While originally built to run on a laptop during a famous infosec conference to see how many pings and pokes we could attract, it sould be useful for research and reconnaissance to test networks for infestations. 



https://hub.docker.com/r/k0st/cowrie/
https://github.com/kost/docker-cowrie
https://hub.docker.com/r/gliderlabs/alpine/

## Honeypots

prickly-pete currently brings up the following honeypots, automatically, with no configuration necessary.

* [cowrie](https://github.com/micheloosterhof/cowrie) - a medium interaction SSH honeypot designed to log brute force attacks and, most importantly, the entire shell interaction performed by the attacker. Based on Kippo by Upi Tamminen (desaster).
* [glastopf](https://github.com/mushorg/glastopf) - Glastopf is a Python web application honeypot founded by Lukas Rist.
* [honeypot-for-tcp-32764](https://github.com/knalli/honeypot-for-tcp-32764) - a first try to mock the router backdoor "TCP32764" found in several router firmwares at the end of 2013. The POC of the backdoor is included with the project.
* [contpot](https://pypi.python.org/pypi/Conpot) - an ICS honeypot with the goal to collect intelligence about the motives and methods of adversaries targeting industrial control systems
* [nepenthes](http://nepenthes.carnivore.it/)- a honeypot that works by emulating widespread vulns and then catches and stores viruses worms using these vulns (working to implement [Dionaea](http://dionaea.carnivore.it/) to take its place)"

## Usage

```
git clone https://github.com/philcryer/prickly-pete.git
cd prickly-pete
cp config.cfg.example config.cfg
```

And you're ready to go, feel free to look things over, edit `config.cfg` if you want, then kick it off:

```
./prickly-pete.sh
```

## Testing

### See what you can see

* cowrie - `ssh` to the port, logging in as root (yes, the password can be blank)

```
ssh localhost -p 22 -l root
```

* glastopf - use `curl` against the port to see what it returns 

```
curl localhost
```

or point a browser to [http://localhost/](http://localhost/)

* honeypot-for-tcp-32764 - run `nmap` against the port to see that it's open (need to figure out what else it can tell us)

```
# nmap -p 32764 localhost

Starting Nmap 6.47 ( http://nmap.org ) at 2015-07-31 14:33 GMT
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000034s latency).
Other addresses for localhost (not scanned): 127.0.0.1
PORT      STATE SERVICE
32764/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 1.03 seconds
```

* contpot - ssh to the port (note that the MAC address can be changed in the config for further confusion)

```
$ curl localhost:50100
Welcome...
Connected to [00:13:EA:00:00:00]

? Command not found.
Send 'H' for help.
```

* other, more general poking, like nmap'ing the entire box

```
# nmap localhost
```

* checking out all the open ports

```
netstat -plunt
```

## Silly

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

## License

The MIT License (MIT)

Copyright (c) 2015 philcryer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

### Thanks

# prickly-pete
A setup script to bring up a box laden with various honeypots running as many exposed services as possible. While originally built to run on a laptop during a famous infosec conference to see how many pings and pokes we could attract, it could be useful for research, testing for bug in a network or other interesting things. 

## Usage

```
git clone https://github.com/philcryer/holy-box.git
cd holy-box
cp config.cfg.example config.cfg
```

And you're ready to go, feel free to look things over, edit `config.cfg` if you want, then kick it off:

```
./prickly-pete.sh
```

## Testing

### See what you can see

* glastopf

```
curl localhost
```

_or view in a browser_

* cowrie

```
ssh localhost -p 22 -l root
```

_password can be blank_

## Silly

George, driving in the car with the Rosses: "And that leads into the master
bedroom."
__Mrs. Ross:__ "Tell us more."
__George:__ "You want to hear more? The master bedroom opens into the solarium."
__Mr. Ross:__ "Another solarium?"
__George:__ "Yes, two solariums. Quite a find. And I have horses, too?"

![](src/imgs/snoopy_and_prickly_pete.jpg)

__Mr. Ross:__ "What are their names?"
__George:__ "Snoopy and Prickly Pete. Should I keep driving?"
__Mrs. Ross:__ "Oh, look, an antique stand. Pull over. We'll buy you a
housewarming gift."
__George, chuckling to himself:__ "Housewarming gift."
__George, swerving the car to go to the antique stand:__ "All right, we're taking
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

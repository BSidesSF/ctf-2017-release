# ctf-2017
Challenges for the 2017 BSidesSF CTF
https://ctftime.org/event/414

Built by [@iagox86](https://twitter.com/iagox86), [@itsC0rg1](https://twitter.com/itsC0rg1), [@bmenrigh](https://twitter.com/bmenrigh), [@matir](https://twitter.com/matir), [@CornflakeSavage](https://twitter.com/CornflakeSavage)

## Running the challenges locally
You can run all the challengs locally with docker.
```
docker-compose build && docker-compose up -d
```
Challenges will be available at `http://localhost:PORT`
HTTP-based challenges start at port 8000, tcp challenges start at port 9000

If you are not familiar with docker, two options for installing docker are described at the bottom of this document.

## Challenges ##
On-site challenges are marked with *

| Challenge Name | Category | Points |
|----------------|----------|--------|
| easyauth | Web | 30 |
| zumbo 1 | Web | 20 |
| zumbo 2 | Web | 100 |
| zumboa 3 | Web | 250 |
| Delphi Status | Crypto/Web | 250 |
| the-year-2000 | Web | 100 |
| Easy | Reversing | 10 |
| Skipper | Reversing | 75 |
| Skipper2 | Reversing | 200 |
| Disarming | Reversing | 400 |
| Flag Receiver | Mobile/Reversing | 200 |
| Pinlock | Mobile/Reversing | 150 |
| EasyArm | Reversing | 150 |
| Steel Mountain: Sensors | Pwn | 150 |
| SteelMountain: Setpoint | Pwn | 350 |
| bytme | Pwn | 200 |
| hashecute | Pwn | 100 |
| b-64-b-tuff | Pwn | 100 |
| Nibbler | Pwn/Programming | 666 |
| Easyshell | Pwn | 30 |
| Easyshell64 | Pwn | 30 |
| i-am-the-shortest | Pwn | 200 |
| beez-fight | Misc | 350 |
| NOP | Misc | 20 |
| *Locker | Misc | 150 |
| *On-sight | Misc | 1 |
| dnscap | Forensics | 500 |
| easypcap | Forensics | 40 |
| ximage | Forensics | 300 |
| hex-ray | Forensics | 250 |
| matroyshka | Forensics | 666 |
| shattered | Forensics | 200 |
| Latlong | Forensics | 150 |
| in-plain-sight | Crypto | 100 |
| []root | Crypto | 250 |
| vhash | Crypto | 450 |
| vhash-fixed | Crypto | 450 |
| *Shared Secrets | Crypto | 250 |

Challenges not included in this repository (mostly trivia questions)

| Challenge Name | Category | Points | 
|----------------|----------|--------|
| Hackers | Misc | 1 | 
| Ancient Hop Grain Juice | Misc | 1 | 
| Way Before Nirvana | Misc | 10 | 
| The Wrong Cipher | Misc | 1 | 
| The Right Cipher | Misc | 1 | 
| Let's play a game | Misc | 1 | 
| Quote | Misc | 1 | 
| Critical Infrastructure | Misc | 20 | 


### Running the containers in a Vagrant VM (recommended for Linux)
This repo has a VM that allows you to run the docker containers. To get started:

1. Install Virtualbox and vagrant
2. In your clone of this repo run `vagrant up`. This will create the VM, and install docker in it.
3. `vagrant ssh` to ssh into the VM.
4. `cd /vagrant` (all files from the local directory are mounted into the vm in /vagrant)
5. To start the containers `docker-compose build && docker-compose up -d`
6. You can now view the containers at http://10.10.10.20:PORT_NUM
7. `docker-compose kill` to stop the containers

### Running the containers with Docker (Recommended for OSX and Windows)
1. Install docker and docker-compose on your machine however you choose (for OSX and windows docker has a nice standalone package)
2. In this repo `docker-compose build && docker-compose up -d`
3. View the containers at http://localhost:PORT_NUM
4. Stop with `docker-compose kill`

### Deploying
Here be dragons! Most of the CTF infrastructure was run on kubernetes. While it certainly made deploying and maintaining our challenges simple, there are many reasons why
docker and kubernetes might not be a good choice for CTF challenges.

We wrote a blog post about some potential security issues when using this platform, one of these issues is unfixed in this repository. Please take a look before reusing the infrastructure configs as-is.
https://hackernoon.com/capturing-all-the-flags-in-bsidessf-ctf-by-pwning-our-infrastructure-3570b99b4dd0

Any questions? Feel free to open an issue or reach out on twitter.

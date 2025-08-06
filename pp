#!/usr/bin/env bash
#===============================================================================
# Description: A script using Docker and Docker Compose to quickly bring up some
#    honeypots exposing lots of services. For research, reconnaissance, and fun. 
# Source:  https://github.com/philcryer/prickly-pete
# Author: philcryer < phil at philcryer dot com >
# License: MIT
#=============================================================================

set -e

## prompts
function msg_status () {
    echo -e "\x1B[01;34m[*]\x1B[0m $1" 
}
function msg_good () { 
    echo -e "\x1B[01;32m[*]\x1B[0m $1" 
}
function msg_error () { 
    echo -e "\x1B[01;31m[*]\x1B[0m $1" 
}
function msg_notification () { 
    echo -e "\x1B[01;33m[*]\x1B[0m $1"
}

## usage
usage() { 
    echo "Usage: pp [build] [start] [stop] [status] [logs] [clean] [nuke]"
    echo "  build: build projects"
    echo "  start: start, and build if required, all containers"
    echo "  stop: stop all containers"
    echo "  status: show the running status of all containers"
    echo "  scan: scan ports on localhost (requires nmap)"
    echo "  logs: show live logs from all containers"
    echo "  clean: remove all containers"
    echo "  nuke: clean, but also remove all collected data and logs"
    exit 0
}
expr "$*" : ".*--help" > /dev/null && usage
expr "$*" : ".*-h" > /dev/null && usage
expr "$*" : ".*help" > /dev/null && usage
if [[ $# -eq 0 ]] ; then
	usage
fi
if [[ $# -gt 1 ]] ; then
	usage
fi

## logo
logo(){
    echo "____________"
    echo "| ___ \ ___ |   Prickly"
    echo "| |_/ / |_/ /   e"
    echo "|  __/|  __/    t     - honeypots, running in docker"     
    echo "| |   | |       e     - created in 2019, updated Summer 2025"
    echo "\_|   \_|"
    echo
}
logo;

## functions
checkout(){
    msg_notification "checking out code"
    if [ ! -d 'src/conpot' ]; then
        msg_status "conpot: checking out"
        git clone https://github.com/mushorg/conpot.git src/conpot
    fi
    msg_notification "conpot: checked out"

    if [ ! -d 'src/cowrie' ]; then
        msg_status "cowrie: checking out"
        git clone https://github.com/cowrie/cowrie.git src/cowrie
    fi
    msg_notification "cowrie: checked out"

    if [ ! -d 'src/heralding' ]; then
        msg_status "heralding: checking out"
        git clone https://github.com/johnnykv/heralding.git src/heralding
    fi
    msg_notification "heraldinge: checked out"

    if [ ! -d 'src/honeyaml' ]; then
        msg_status "honeyaml: checking out"
        git clone https://github.com/mmta/honeyaml.git src/honeyaml
    fi
    msg_notification "honeyaml: checked out"


    #if [ ! -d 'src/ciscoasa_honeypot' ]; then
    #    msg_status "ciscoasa_honeypot: checking out"
    #    git clone https://github.com/Cymmetria/ciscoasa_honeypot.git src/ciscoasa_honeypot
    #fi
    #msg_notification "honeyaml: checked out"

    #if [ ! -d 'src/ddospot-master-' ]; then
    #    msg_status "ddospot: checking out"
    #    #git clone https://github.com/aelth/ddospot.git src/ddospot
    #    cd src
    #    curl -L -O https://github.com/aelth/ddospot/archive/refs/heads/master.zip
    #    unzip master.zip
    #    cd -
    #fi
    #msg_notification "ddospot: checked out"
}

build(){
    msg_notification "build starting"
    export COMPOSE_BAKE=true

    msg_status "cowrie: building container"
    docker compose pull
    msg_good "cowrie: container built"

    msg_status "conpot: building container"
    docker compose pull
    msg_good "conpot: container built"

    msg_status "heralding: building container"
    docker compose pull
    msg_good "heralding: container built"

    msg_status "honeyaml: building container"
    docker compose pull
    msg_good "honeyaml: container built"

    #msg_status "ciscoasa_honeypot: building container"
    #docker compose pull
    #msg_good "ciscoasa_honeypot: container built"

    #msg_status "ddospot: building container"
    #docker compose pull
    #msg_good "ddospot: container built"
}

volumes(){
    echo; msg_notification "volumes: all container volumes holding logs and output data"
    tmpfile=/tmp/pp.XXXXXX
    docker_volumes=$(docker volume ls --filter "name=ppv" --format "table {{.Name}} - {{.Mountpoint}}" > $tmpfile)
    cat $tmpfile; rm $tmpfile
}

## actions
if [[ ${1} == 'build' ]] ; then
    msg_notification "build: building containers"
    checkout;
    build; 
fi

if [[ ${1} == 'start' ]] ; then
    msg_notification "start: starting containers"
    checkout;
    build; 
    docker compose up -d
fi

if [[ ${1} == 'stop' ]] ; then
    msg_notification "stop: stopping containers"
    docker compose stop
fi

if [[ ${1} == 'status' ]] ; then
    msg_notification "status: running containers and their ports"
    docker compose ps
    volumes;
fi

if [[ ${1} == 'scan' ]] ; then
    msg_notification "scan: scanning local ports via nmap (nmap -p- localhost)"
    nmap -p- localhost
fi

if [[ ${1} == 'logs' ]] ; then
    msg_notification "logs: show live container logs"
    docker compose logs -f
fi

if [[ ${1} == 'clean' ]] ; then
    msg_notification "clean: stop and bring all containers down"
    docker compose down
    volumes;
fi

if [[ ${1} == 'nuke' ]] ; then
    msg_notification "nuke: stop and bring all containers down, and remove all volumes"
    docker compose down
    docker compose down --rmi all -v
fi

exit 0

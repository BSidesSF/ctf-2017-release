#!/bin/bash
# This script is meant to run as root in the VM
set -e

function install_docker() {
    echo "Installing docker"
    apt-get install -y apt-transport-https ca-certificates
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

    mkdir -p /etc/apt/sources.list.d/
    echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

    apt-get update
    apt-get purge lxc-docker

    apt-get install -y apparmor
    apt-get install -y linux-image-extra-$(uname -r)
    apt-get install -y linux-image-generic-lts-trusty

    apt-get install -y docker-engine
    usermod -aG docker vagrant
}

function install_docker_compose() {
    echo "Installing docker-compose"
    apt-get install -y python-pip
    pip install docker-compose
}

apt-get update
install_docker
install_docker_compose

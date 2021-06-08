#!/bin/bash

### MODE SECURE
set -u # en cas de variable non définit, arreter le script
set -e # en cas d'erreur (code de retour non-zero) arreter le script

### Lists with some of the packages to install.
PACKAGES_LIST="apt-transport-https ca-certificates curl gnupg lsb-release conntrack"
DOCKER_PACKAGES="docker-ce docker-ce-cli containerd.io"


# Check the script is run as root user.
ps_assert_root(){
	REAL_ID="$(id -u)"
	if [ "$REAL_ID" -ne 0 ]; then
		1>&2 echo "ERREUR: Le script doit etre exécuté en tant que root"
		exit 1
	fi
}

# Check if a package is already installed on the machine, if not then install it.
ps_check_install_package() {
    PACKAGE_NAME="$1"
	apt update
    if ! dpkg -l |grep --quiet "^ii.*$PACKAGE_NAME " ; then
        apt install -y "$PACKAGE_NAME"
		echo "INFO: $PACKAGE_NAME has been installed"
    else
        echo ""
        echo "$PACKAGE_NAME est déjà installé."
    fi
}


# Allows to pass a list of packages as parameter. Then summon the ps_check_install_package method on each element of the list.
ps_install_packages() {
	for i in $( seq 1 1 $# ); do 
		PACKAGE=${!i}
		echo "$PACKAGE will be installed"
    # Instalation du package
		ps_check_install_package "$PACKAGE"
	done
}


# Install all packages required for further installations.
ps_install_prerequisites() {
	ps_install_packages $PACKAGES_LIST
}


# Get GPG key for kubernetes then take care of installing it.
ps_install_kubernetes() {
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
	ps_check_install_package kubectl
}


# Get minikube binary and install it. Removes the binary file afterwards.
ps_install_minikube() {
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	install minikube-linux-amd64 /usr/local/bin/minikube
	rm -f minikube-linux-amd64
}


# Start the minikube. Logs minikube status.
ps_start_minikube() {
	apt install -y conntrack
	minikube start --driver=none
	if [ $? -eq 0 ] ; then
		echo "minikube started"
	else
		echo "ERROR: minikube failed to start"
	fi
}


# Install Docker. Docker is used on this vm as the driver for minikube.
ps_install_docker() {
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
	  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	 
	ps_install_packages $DOCKER_PACKAGES
}


# First make sure the rights are OK.
ps_assert_root

# Install all needed packages for further installations.
ps_install_prerequisites

#Install Docker to drive minikube.
ps_install_docker

# Manage Kubernetes part.
# Install kubectl.
ps_install_kubernetes
# Install minikube.
ps_install_minikube

# Start minikube
ps_start_minikube
MINIKUBE_IP=$(minikube ip)
#echo "$MINIKUBE_IP game-test.com" >> /etc/hosts
#echo "$MINIKUBE_IP game-dev.com" >> /etc/hosts
#echo "$MINIKUBE_IP game-prod.com" >> /etc/hosts

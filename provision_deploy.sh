#!/bin/bash

### MODE SECURE
set -u # en cas de variable non définit, arreter le script
set -e # en cas d'erreur (code de retour non-zero) arreter le script

# Vérifier que le script est lancé en tant que root
ps_assert_root(){
	REAL_ID="$(id -u)"
	if [ "$REAL_ID" -ne 0 ]; then
		1>&2 echo "ERREUR: Le script doit etre exécuté en tant que root"
		exit 1
	fi
}

ps_check_install_packages() {
    PACKAGE_NAME="$1"
	apt update
    if ! dpkg -l |grep --quiet "^ii.*$PACKAGE_NAME " ; then
        apt install -y "$PACKAGE_NAME"
    else
        echo ""
        echo "$PACKAGE_NAME est déjà installé."
    fi
}

ps_install_kubernetes() {
    ps_check_install_packages apt-transport-https
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
	ps_check_install_packages kubectl
}

### POINT D'ENTRER DU SCRIPT ###

## Vérifier que le script est lancé en tant que root
ps_assert_root

# install env kub
ps_install_kubernetes

echo "Success"
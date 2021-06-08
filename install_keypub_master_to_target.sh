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

ps_test_user_jenkins(){
	echo "************************* ps_test_user_jenkins*******************"
	echo "jenkins:jenkins" | sudo chpasswd
	echo "************************* chpasswd*******************"
	export SSHPASS=jenkins
	echo "************************* SSHPASS*******************"
	su - jenkins -c "ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y 2>&1 >/dev/null"
	echo "************************* keygen*******************"
	su - jenkins -c 'sshpass -p jenkins ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no jenkins@172.30.1.16'
	echo "************************* copy*******************"
}
### POINT D'ENTRER DU SCRIPT ###

## Vérifier que le script est lancé en tant que root
ps_assert_root

## ps_test_user_jenkins
ps_test_user_jenkins
echo ""
echo "Success"
echo "A reboot is required !!"



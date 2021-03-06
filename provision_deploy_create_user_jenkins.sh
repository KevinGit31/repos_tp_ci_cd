#!/bin/bash

### MODE SECURE
set -u # en cas de variable non définit, arreter le script
set -e # en cas d'erreur (code de retour non-zero) arreter le script

USER_JOB_JENKINS="jenkins"
HOME_BASE="/home/"
HOME_JENKINS="${HOME_BASE}${USER_JOB_JENKINS}"

# Vérifier que le script est lancé en tant que root
ps_assert_root(){
	REAL_ID="$(id -u)"
	if [ "$REAL_ID" -ne 0 ]; then
		1>&2 echo "ERREUR: Le script doit etre exécuté en tant que root"
		exit 1
	fi
}

ps_verif_user_jenkins_exist(){
    if id "$USER_JOB_JENKINS" 2>/dev/null ; then
        echo "$HOME_JENKINS exist we have to delete it"
        sudo userdel userjenkins
        sudo rm -rf $HOME_JENKINS
    fi
}

ps_create_update_user_jenkins(){
    if ! id "$USER_JOB_JENKINS" 2>/dev/null ; then
      echo "$USER_JOB_JENKINS doit être créé"
      # on creer le nouvel utilisateur
      sudo useradd -d $HOME_BASE$USER_JOB_JENKINS -s /bin/bash -m $USER_JOB_JENKINS
      echo "$USER_JOB_JENKINS:$USER_JOB_JENKINS" | sudo chpasswd
      [ $? -eq 0 ] && echo "User $USER_JOB_JENKINS has been added !" || echo "Failed !"
	  sudo cp /etc/sudoers /etc/sudoers.old
	  echo " " | sudo tee -a /etc/sudoers
	  echo "# Add privilege root to user jenkins " | sudo tee -a /etc/sudoers
      echo "$USER_JOB_JENKINS ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers
    fi
}

ps_authorize_copy_ssh(){
	sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
	systemctl restart sshd.service
}

### POINT D'ENTRER DU SCRIPT ###

## Vérifier que le script est lancé en tant que root
ps_assert_root
# verify if user jenkins exist
ps_verif_user_jenkins_exist
# create user jenkins
ps_create_update_user_jenkins
# authorize copy key pub
ps_authorize_copy_ssh

echo "Success"

#!/bin/bash

### MODE SECURE
set -u # en cas de variable non définit, arreter le script
set -e # en cas d'erreur (code de retour non-zero) arreter le script

USER_JOB_JENKINS="jenkins"
HOME_BASE="/home/"
HOME_JENKINS="${HOME_BASE}${USER_JOB_JENKINS}"
ps_verif_user_jenkins_exist(){
    if id "$USER_JOB_JENKINS" 2>/dev/null ; then
        echo "$HOME_JENKINS exist we have to delete it"
        sudo userdel $USER_JOB_JENKINS
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
    fi
}

ps_authorize_copy_ssh(){
	sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
	systemctl restart sshd.service
}
### debut du script
# verify if user jenkins exist
ps_verif_user_jenkins_exist
# create user jenkins
ps_create_update_user_jenkins
# authorize copy key pub
ps_authorize_copy_ssh

echo "Success"

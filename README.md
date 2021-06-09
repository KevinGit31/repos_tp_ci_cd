# Sujet TP – CI/CD

**Ce document a pour but de guider et d'aider l'utilisateur à installer les différents environnements, exécuter les différents scripts.**

## Organisation du projet

Pour pouvoir mener à bien ce projet, le premier jour nous avons recueilli les besoins du client que nous avons transformé en story. 
Toutes ces stories, nous les avons mises sur notre taskworld.
Chaque story a été découpée en petite tâche par la suite. Dans la continuité, une fois toutes les tâches recensées, nous avons commencé à mettre en place les différents environnement.

Le document va se présenter en 3 parties:

0. Pré-requis
1. Installation de l'environnement CI/CD
2. Installation de notre serveur jenkins sur l'interface web
3. Fonctionnement du CI/CD

## Information sur notre environnement CI/CD
|Serveurs  | Noms Serveurs Vagrant |     @IP    | Port |
| ------------- |:-------------:|:-------------|-----------------------|
| Master     | envjenkins    |   172.30.1.15            | |
| target      | envdeply     |   172.30.1.16            |  |

## Comment fonctionne notre chaine d'intégration

### Architecture Applicative

![Architecture Applicative.](https://raw.githubusercontent.com/KevinGit31/depot-application-python_v1/readme/diagramme/Architecture_Applicative.png "Diagramme.")

## 0. Pré-requis

L'essentiel des installations nécessaires pour lancer et faire fonctionner ce projet sont automatisées et réalisées à l'intérieur des machines virtuelles (vm) générées sur la base du fichier "Vagrantfile" qu'il est possible de retrouver dans le dossier source du projet.
Les seules installations à réaliser par l'utilisateur pour être en mesure de lancer le projet sont celles permettant de le récupérer depuis le dépot Github sur lequel il est stocké (ie Git) et celles permettant de lancer et faire tourner les vm (ie Vagrant et Virtualbox).

Il est considéré comme déjà établi que l'utilisateur possède une machine sur laquelle une version récente de Windows est disponible, et qu'un navigateur internet est déjà installé.

Pour réaliser les installations de Vagrant et de Git nous passerons pas l'intermédiaire de Chocolatey, qui est donc à installer en sus.

### Installation de Chocolatey

Veuillez suivre les étapes décrites dans la partie 2 de la page "Installating Chocolatey" que l'on retrouve en suivant l'url "chocolatey.org/install".

### Installation de VirtualBox

Rendez-vous à l'url virtualbox.org/wiki/Downloads. Puis cliquez sur le lien "Windows hosts" dans la section "VirtualBox 6.1.22 platform packages".
Le téléchargement de l'installer de VirtualBox se lance.
Aller dans le dossier téléchargement, double cliquer sur l'exécutable qui a été télécharger et suivre les étapes de l'installation de Virtualbox.

### Installation de Vagrant et Git

Pour installer vagrant ouvrir en tant qu'administrateur un invite de commande Windows (taper commande dans la barre de recherche de Windows).
Puis taper la commande "choco install vagrant". Attendre la fin de l'installation.
Ensuite pour installer Git taper la commande "choco install git.install". Attendre la fin de l'installation.

### Récupération du projet depuis Github

Créer un dossier dans lequel sera stocké le contenu du projet.
Entrer dans ce dossier et faire un clic droit. Sélectionner "Git Bash Here" et cliquer dessus.
Un invite de commande Git Bash doit s'ouvrir.
Dans cet invite de commande taper la commande suivante : "git clone https://github.com/KevinGit31/repos_tp_ci_cd.git "
A la fin du clone un dossier "repos_tp_ci_cd" doit maintenant être présent. Entrer dedans avec la commande "cd repos_tp_ci_cd".

Vous êtes maintenant prêt(e) à réaliser les étapes suivantes et installer la chaîne CICD mise en place au cours de ce projet.

## 1. Installation de l'environnement CI/CD

Notre environnement est composé de deux serveurs: 
- un serveur "jenkins" sur lequel jenkins est installé et à partir duquel nous accèderons à l'interface web de jenkins. Ansible y est également installé et il nous servira donc également de master pour le playbook ansible.
- un serveur "deploy" qui sera le target du playbook ansible. Sur celui-ci nous installons l'environnement kubernetes et c'est à partir de lui que nous lancerons le cluster kubernetes qui déploiera les trois environnements.

Pour installer ces deux serveurs il suffit de jouer la commande "vagrant up", dans un terminal (Git bash par exemple) ouvert dans le dossier source du projet, qui lancera l'installation des deux serveurs de manière automatique.

Le nom du serveur jenkins est "envjenkins" et celui du serveur de déploiement est "envdeploy".

Il est nécessaire de d'abord créer la vm du serveur de déploiement puis celle du serveur jenkins. En effet l'installation du serveur jenkins contient des étapes consistant à préparer la connexion ssh du serveur jenkins vers le serveur de déploiement, entre autre par partage de clefs. Cette action ne peut être réalisée que dans le cas où le serveur de déploiement est déjà opérationnel.

En temps normal il suffit de jouer la commande "vagrant up" dans le dossier source du projet pour lancer la création de la vm de déploiement puis de la vm jenkins. Si jamais besoin était de créer chaque vm séparément les commandes sont les suivantes:
- "vagrant up envdeploy" pour créer la vm du serveur de déploiement.
- "vagrant up envjenkins" pour créer la vm du serveur jenkins.
La création de la vm du serveur jenkins ne doit pas être lancée tant que le serveur de déploiement n'est pas opérationnel. Pour vérifier l'état de la vm de déploiement il suffit de taper la commande "vagrant status" dans un terminal ouvert dans le dossier source du projet. Si le "state" de envdeploy est différent de "running" il faut alors jouer d'abird la commande "vagrant destroy -f envdeploy" puis la commande "vagrant up envdeploy", avant de joeur la commande "vagrant up envjenkins".
Si la vm du serveur de déploiement est lancée seule via la commande "vagrant up envdeploy" dans un terminal ouvert dans le dossier source du projet alors il est nécessaire de détruire la vm jenkins puis de la recréer pour s'assurer de la bonne connexion entre les deux machines. Ceci à l'aide des commandes "vagrant destroy -f envjenkins" puis "vagrant up envjenkins" toutes deux tapées dans un terminal ouvert dans le dossier source du projet.

### Serveur de deploiement
#### Installation de l'environnement Kubernetes

Nous avons fait le choix d'utiliser Minikube (serveur mono node kubernetes).
Les installations liées à Kubernetes vont donc se regrouper en deux parties: l'installation de kubernetes lui-même et celle de Minikube.
##### Installation de Kubernetes

Tout d'abord une première phase avec quelques installations d'utilitaires qui vont permettre de simplifier les installations suivantes.
Puis récupération de la clef gpg de kubernetes, et l'installation du package de Kubectl.

##### Installation et lancement de Minikube

Par défaut Minikube se lance en utilisant VirtualBox comme driver, mais d'autres sont utilisables. Sur notre VM Linux VirtualBox n'est pas une option.
Deux drivers nous intéressent : docker et none. Le driver "none" est celui recommandé pour lancer Minikube dans une VM.
L'utilisation de ce driver nécessite tout de même l'installation de docker. Elle demande aussi que conntrack soit installé et que l'utilisateur soit root.
On commence par installer conntrack et docker.
Puis on récupère le package de Minikube et on l'installe.
Enfin on lance Minikube, qui va donc tourner dès la création de la VM, sur le compte root, avec la commande minikube start --driver=none.


#### Création du user jenkins

### Serveur Jenkins





# Sujet TP – CI/CD

**Ce document a pour but de guider et d'aider l'utilisateur à installer les différents environnements, exécuter les différents scripts.**

## Organisation du projet

Pour pouvoir mener à bien ce projet, le premier jour nous avons recueilli les besoins du client que nous avons transformé en story. 
Toutes ces stories, nous les avons mises sur notre taskworld.
Chaque story a été découpée en petite tâche par la suite. Dans la continuité, une fois toutes les tâches recensées, nous avons commencé à mettre en place les différents environnement.

Le document va se présenter en 3 parties:

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

## 1. Installation de l'environnement CI/CD

### Serveur Jenkins

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



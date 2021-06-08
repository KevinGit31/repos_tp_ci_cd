# Sujet TP – CI/CD

**Ce document a pour but de guider et d'aider l'utilisateur à installer les différents environnements, exécuter les différents scripts.**

## Organisation du projet

Pour pouvoir mener à bien ce projet, le premier jour nous avons recueilli les besoins du client que nous avons transformé en story. 
Toutes ces stories, nous les avons mises sur notre trello.
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


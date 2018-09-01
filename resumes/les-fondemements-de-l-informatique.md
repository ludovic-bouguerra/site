---
layout: resume
title:  "Les fondements de l'informatique"
date:   2018-08-12 22:03:00 +0200
categories: resume fondements informatique
long_description: "Résumé du livre 'les fondements de l'informatique"
redirect_from: ""

---

Présentation du processeur, et de l'ordinateur à différentes échelles. L'auteur part d'une vision microscopique pour, à chaque chapitre, ajouter une dimension supplémentaire. Son objectif étant de montrer le fonctionnement d'un ordinateur seul et dans un environnement distribué.

Dans un premiers temps il y'a une étude du fonctionnement du processeur puis du couple processeur mémoire. Ensuite l'auteur nous présente comment des périphériques peuvent interagir avec le système. Par là suite nous une étude du fonctionnement de l'intégration d'un ordinateur dans un réseaux d'ordinateur est présenté. Dernier point présentant le fonctionnement "interne" des ordinateurs c'est la présentation des systèmes d'exploitations. Enfin il présente comment il est possible de développer des applications et comment fonctionnent les applications d'entreprises (  langages de développements, bases de données, architectures ).

### Étude du processeur et du couple processeur / mémoire

L'ordinateur est une **machine à état**. Chaque état peut être stocké dans les registres, dans la mémoire ou dans le disque dur. Une mémoire est association de valeurs disponible à une adresse donnée.

Il est possible de faire des opérations de bases sur chacune de ces adresses entre autre:
 - charger en mémoire
 - Additionner / soustraire
 - Multiplier / diviser


Ces **opérations de bases** sont utilisables à travers un langage de programmation : **l'assembleur**.


### Périphériques entrées / sorties

Les périphériques d'entrées sorties peuvent être assimilés aux divers sens du corps humains. Il s'agit de données que le processeur va recevoir de différentes sources qui vont lui permettre ensuite d'effectuer des traitements et transmettre des données. Toutefois là ou le corps dispose que les nerfs afin de transmettre et recevoir les informations qui sont transmisses au cerveau. L'ordinateur possède quant à lui une variété de **bus de données** qui ont le rôle de transmettre les données. La question qui peut finalement se poser: Pourquoi finalement différents bus de données alors que nous transmettons qu'un signal électrique. En fait un bus de données est caractérisé principalement par sa **vitesse** et **le sens** dans lequel la communication peut se faire. Par exemple certains permettent la communication en simultanée dans les deux sens, d'autres dans un sens.

L'auteur présente le fonctionnement des périphériques suivants :
- Ecrans
- Claviers
- souris

L'auteur nous explique la différence entre un **contrôleur**, un **bus** et un **port** ce qui constitue les éléments essentiels de la communications entre les périphériques et le processeur. Nous apprenons aussi comment chaque périphériques peuvent attirer l'attention du processeur afin d'exécuter une tâche précise. Ce sont les **IRQ** pour interrupt request, c'est un mécanisme qui permet aux périphériques d'annoncer qu'un événement important nécessitant de lancer une opération immédiate vient de se produire. Il peut s'agir par exemple de la pression d'une touche du clavier.

Enfin le mode **DMA** nous est présenté, c'est un mode de transfert de données utilisé lorsque la quantité de donné est importante. L'objectif est de réduire les actions du processeur. Les périphériques peuvent directement écrire sur une plage d'adresse mémoire et dès que l'opération est terminée il est possible de prévenir le processeur par l'intermédiaire d'une IRQ.


### Les systèmes d'exploitations

L'auteur présente les différentes familles de systèmes d'exploitation partant du BIOS, Windows, Linux, Unix, Mac OS et une partie est réservée aux systèmes d'exploitations mobiles.

Ce chapitre présente également le rôle des systèmes d'exploitations ainsi que les différentes architectures possibles. En résumé son rôle est de permettre de faire le lien entre le matériel et les applications des utilisateurs.

Il assure :
* La gestion des processus
* La gestion de la mémoire
* La gestion des fichiers
* La gestion des entrées sorties
* La gestion des réseaux

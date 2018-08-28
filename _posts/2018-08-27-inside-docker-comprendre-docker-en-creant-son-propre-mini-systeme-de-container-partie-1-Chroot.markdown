---
layout: post
title:  "Inside Docker : comprendre Docker en créant son propre mini système de container - partie 1 - Chroot."
date:   2017-08-14 11:01:00 +0200
categories: docker chroot linux kernel namespace
long_description: Dans cette série de tutoriaux nous mettrons en place un mini système de container dans le but de comprendre comment fonctionne Docker. 
thumbnail: /images/posts/comprendre-docker-en-creant-son-propre-mini-systeme-de-container-p1/thumbnail.jpeg

---

Pour ceux qui souhaitent un peu mieux comprendre le fonctionnement de Docker. Nous allons développer notre propre mini-système de container qui fonctionnera que sous Linux et qui offrira un système similaire de création d'images (par un système d'overlay), tout cela en plusieurs parties.

Pour arriver à correctement suivre vous devrez avoir une connaissance minimale de Python et de Linux. Je développerai sur Ubuntu 16.04.

Ce que nous essaierons de faire:
- Un fichier service-specs.yml qui décriera notre container.
- Ce container aura une adresse IP et pourra "exposer" un ou des ports sur l'hôte
- Enfin nous pourrons partager un / des volumes entre des hôtes.
- Avec pour objectif d'isoler l'ensemble des ressources, afin d'éviter qu'un processus puisse impacter le fonctionnement d'un autre présent dans un autre container ou sur l'hôte.

Pour cela nous utiliserons des fonctionnalités offertes par le noyau Linux (cgroup qui permet d'isoler les ressources) et quelques commandes de base des systèmes Unix notamment chroot.

Dans cette première partie nous aborderons le sujet de l'isolation des fichiers grâce à la commande chroot, et quelles sont ses limites.

Nous allons d'abord créer un système de fichier racine basé sur une Debian Jessie minimal.

Pour créer notre système Debian nous utiliserons deboostrap qui permet de télécharger les paquets nécessaire pour créer une distribution basée sur Debian (donc Ubuntu et autres ...).

```
sudo apt-get install debootstrap
```

Commençons donc par créer notre petit système :

Avec la commande ci-dessous nous allons créer un système Debian dans le dossier rootfs. --variant=minbase permet d'installer le minimum de paquet nécessaire pour que Débian fonctionne.

```
sudo debootstrap --variant=minbase jessie rootfs
```

Pour plus de détails la documentation de deboostrap est disponible ici : https://manpages.debian.org/stretch/debootstrap/debootstrap.8.en.html

Lorsque l'opération est terminée nous obtenons dans le dossier rootfs notre système Debian prêt à l'emploi.

En effet en faisant :

```
cd rootfs && ls
```

On constate que l'architecture des dossiers ressemble fortement à notre dossier racine. Toutefois on observant le dossier plus en détails on constate que les certains dossiers sont vides alors que sur notre système racine ils ne le sont pas.

Comparons /proc et rootfs/proc mais aussi /sys rootfs/sys et enfin dev et roofs/dev. Les deux premiers sont vides dans notre rootfs alors qu'ils y a du contenu. Le dossier dev quant à lui est clairement moins complet.

**Mais en fait à quoi servent ces dossiers ?**

/proc est un point de montage représentant un système de fichiers en mémoire qui contiendra des fichiers et dossiers (virtuels) représentant les processus lancés sur le système et leurs état. le programme "ps" lit tout simplement le contenu de ce dossier et le représente dans une forme "human" readable.

Code source procfs : https://github.com/torvalds/linux/tree/master/fs/proc

Code source ps : https://github.com/mirror/busybox/blob/20c0d07e952ab764b6d8d46bfe30c30efcba005c/procps/ps.c

Par exemple pour avoir des information sur le processus avec l'identifiant 1 (le script init, premier programme dans l'espace utilisateur) on peut exécuter

```
cat /proc/1/cmdline
```

Cela nous retourne "/sbin/init splash" C'est la première commande appelée par notre noyau linux.

/sys est un point de montage représentant un système de fichier en mémoire qui permet au noyau de fournir depuis l'espace utilisateur des informations sur la configuration matérielle, les drivers chargés. Et de pouvoir modifier certains paramètres du noyau. Certains "fichiers" sont donc éditables.

Code source sysfs : https://github.com/torvalds/linux/blob/master/fs/sysfs/mount.c

lspci par exemple utilise sysfs pour afficher l'ensemble des périphériques disponibles :

Essayez ! comparez la sortie de :

```
ls /sys/bus/pci/devices/
```

avec "lspci"

/dev : Le dossier dev quant à lui représente des périphériques à entrée / sorties qui se comportent comme des fichiers. A savoir que nous pourrons lire ou écrire des données au même titre qu'en lisant des fichiers. On retrouvera nos disques durs / avec ses partitions, mais aussi les cartes d'acquisitions, claviers, souris.


Par exemple :

```
head -c 1k /dev/sda
```

Affiche le premier kilo octet contenu dans votre disque dur.

Maintenant que nous savons tout ça nous allons essayer la commande chroot qui nous permet de changer le répertoire racine pour un processus donné. Nous allons donc essayer de définir le dossier rootfs comme racine.

Pour cela il faut faire

```
chroot roofs
```

Si à présent le dossier rootfs est notre racine nous ne devrions pas pouvoir remonter au dessus. (Faire un cd .. par exemple).

```
cd ..
```

Nous constatons que nous ne pouvons plus monter au dessus, donc si nous exécutons un processus grâce a chroot il ne devrait pas pouvoir modifier des fichiers qui sont à l’extérieur de ce nouveau dossier racine. Nous avons donc une isolation au niveau des fichiers.

**Qu'en est il au niveau des processus ?**

Observons le contenu des dossier /proc, /sys ils sont tous deux vides. Essayons notre commande ps qui permet de confirmer qu'elle observe bien le contenu de /proc.


```
ps -ax
```

On constate que le programme nous demande d’exécuter cette commande


```
Error, do this: mount -t proc proc /proc
```

Essayons donc de monter le dossier /proc comme demandé et réexécutons la commande ps.

```
mount -t proc proc /proc
ls /proc﻿
ps -ax
```

Le programme ps nous affiche tous les processus existants et le dossier /proc est plein :). Génial !

On constate cependant que nous avons eu accès en tant que root à l'ensemble des processus de la machine. Pour notre système de container nous souhaiterions avoir une isolation à ce niveau là. "Le conteneur ne devrais avoir accès qu'aux processus qu'il à lancé. Essayons par curiosité d’arrêter un processus : (Prenez un identifiant de processus qui ne vous sert pas :) )


```
kill IDPROCESSUS
```

On constate qu'on peux arrêter tous les processus que l'on souhaite.

Nous constatons la même chose pour le dossier /sys il nous faut exécuter la commande suivante pour l'initialiser :

```
mount -t sysfs sys /sys
```

Nous avons le même contenu et que nous pouvons donc lister tous les périphériques mais aussi interagir à notre convenance avec le noyau. A nouveau nous souhaiterions au sein d'un conteneur limiter les accès à ces fonctions.

Enfin le dossier /dev le contenu ne se monte pas directement dans le chroot il faut faire un lien depuis système de fichier racine avec le dossier /dev racine afin d'accéder aux disques durs, caméras etc.. **À l'extérieur du chroot** il faudrait exécuter :

```
sudo mount -o bind /dev rootfs/dev
```

Si nous ne pouvons pas exécuter cette action au sein du chroot nous bénéficions d'un système permettant de protéger nos disques durs et périphériques d'entrées / sorties des applications qui sont dans les containers.

En conclusion nous avons pu voir dans ce tutoriel comment créer un nouvel environnement grâce à Chroot qui protège notre système de fichier racine mais qui ne protège pas nos processus ni de limiter la communication avec le noyau pour l'administrer et gérer les ressources via sysfs.

Dans deux semaines nous essaierons de comprendre comment limiter les accès uniquement aux processus du container.

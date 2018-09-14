---
layout: post
title:  "Raspberry Pi Zero w : Creer un disque flash USB"
date:   2018-09-14 11:01:00 +0200
categories: linux kernel usb device
long_description: Découvrez comment votre Raspberry pi peut faire office de disque flash USB.
thumbnail: /images/posts/raspberry-pi-zero-w-creer-disque-flash-usb/thumbnail.png

---

Le noyau Linux fournit un ensemble de modules catégorisés dans "USB Gadget" qui permettent la création de périphériques USB. Vous y trouverez les périphériques de stockage, webcams, audio etc...

La Raspberry pi Zero dispose d'un port USB qui peut fonctionner comme périphérique, couplé au module noyau g_mass_storage nous allons pouvoir mettre en place notre clé USB virtuelle.

Pour réaliser une clé usb nous allons devoir effectuer les opérations suivantes :

* Créer une image, ajouter une partition et la formater.
* Charger le module noyau correspondant.

Connectez-vous en ssh sur votre périphérique :

## Création d'une image disque


Nous allons créer une image disque d'une taille de 1G.
```
mkdir /data
dd if=/dev/zero of=/data/disk bs=1M seek=1024 count=0
```

Créons une partition ext4
```
fdisk /data/disk
```

Voici le scénario à suivre :

```
Bienvenue dans fdisk (util-linux 2.27.1).
Les modifications resteront en mémoire jusqu'à écriture.
Soyez prudent avant d'utiliser la commande d'écriture.

Le périphérique ne contient pas de table de partitions reconnue.
Création d'une nouvelle étiquette pour disque de type DOS avec identifiant de disque 0xabc57e34.

Commande (m pour l'aide) : n
Type de partition
   p   primaire (0 primaire, 0 étendue, 4 libre)
   e   étendue (conteneur pour partitions logiques)
Sélectionnez (p par défaut) : p
Numéro de partition (1-4, 1 par défaut) :
Premier secteur (2048-2097151, 2048 par défaut) :
Dernier secteur, +secteurs ou +taille{K,M,G,T,P} (2048-2097151, 2097151 par défaut) :

Une nouvelle partition 1 de type « Linux » et de taille 1023 MiB a été créée.

Commande (m pour l'aide) : w
La table de partitions a été altérée.
Synchronisation des disques.

```

Il faut à présent monter le disque :

```
sudo kpartx -a disk

mkfs.ext4 /dev/mapper/loop0p1

sudo mount /dev/mapper/loop0p1 /mnt/disk

sudo touch /mnt/disk/test.txt

sudo umount /dev/mapper/loop0p1

sudo losetup -d /dev/loop0
```

## Installation du module g_mass_storage

```
modprobe g_mass_storage file=/data/disk
```

Branchez à présent le périphérique USB sur votre Raspberry pi, elle sera reconnu comme une clé USB.  

La prochaine fois je vous présenterai comment faire une webcam USB.

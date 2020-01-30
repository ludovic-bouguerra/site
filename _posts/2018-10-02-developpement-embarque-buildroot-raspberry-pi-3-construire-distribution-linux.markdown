---
layout: post
title:  "Développement embarqué : Buildroot et Raspberry pi 3 : Construire une distribution Linux"
date:   2018-10-02 19:30:00 +0200
categories: raspbperry buildroot linux embarque
long_description: Cet article présente l'architecture matérielle d'une box télévision, nous verrons également les utilitaires qui sont utilisés pour générer une distribution.
thumbnail: /images/posts/developpement-multimedia-anatomie-box-tv/thumbnail.png

---

Nous allons dans ce tutoriel utiliser Buildroot afin de générer une distribution Linux pour notre Raspberry Pi 3. Pour suivre ce tutoriel voici l'équipement qui sera nécessaire :

- Raspberry Pi 3 :
- Alimentation :
- Carte SD
- Adaptateur micro SD - SD
- Lecteur de carte SD (si votre ordinateur n'en n'est pas équipé)

Récupérons la dernière version de Buildroot depuis leurs site internet :

Rendez-vous sur le site [de buildroot afin de télécharger la dernière version](https://buildroot.org/).

![Télécharger Buildroot](/images/posts/developpement-embarque-buildroot-raspberry-pi-3-construire-une-distribution-linux/download-buildroot-1.png)


![Télécharger Buildroot](/images/posts/developpement-embarque-buildroot-raspberry-pi-3-construire-une-distribution-linux/download-buildroot-2.png)

Décompressez le fichier le fichier au jour de l'écriture de cet article le suivant :

```
tar -xvf buildroot-2018.02.5.tar.gz
```

Vous aurez besoins des logiciels suivants :


```
cd buildroot-2018.02.5
make raspberrypi3_64_defconfig
make
```

Après quelques temps le résultat de la commande devrait être le suivant :

```
Création d'un fichier normal /media/ludovic/lb/buildroot-2018.02.5/output/images/rootfs.ext2
En train de créer un système de fichiers avec 122880 1k blocs et 30720 i-noeuds.
UUID de système de fichiers=ebce7a37-a7f7-4200-b098-4234ef4be77e
Superblocs de secours stockés sur les blocs :
	8193, 24577, 40961, 57345, 73729

Allocation des tables de groupe : complété                        
Écriture des tables d'i-noeuds : complété                        
Création du journal (4096 blocs) : complété
Copie des fichiers dans le périphérique : complété
Écriture des superblocs et de l'information de comptabilité du système de
fichiers : complété

/usr/bin/install -m 0644 support/misc/target-dir-warning.txt /media/ludovic/lb/buildroot-2018.02.5/output/target/THIS_IS_NOT_YOUR_ROOT_FILESYSTEM
ln -sf rootfs.ext2 /media/ludovic/lb/buildroot-2018.02.5/output/images/rootfs.ext4
>>>   Executing post-image script board/raspberrypi3-64/post-image.sh
vfat(boot.vfat): adding file 'bcm2710-rpi-3-b.dtb' as 'bcm2710-rpi-3-b.dtb' ...
vfat(boot.vfat): adding file 'bcm2837-rpi-3-b.dtb' as 'bcm2837-rpi-3-b.dtb' ...
vfat(boot.vfat): adding file 'rpi-firmware/bootcode.bin' as 'rpi-firmware/bootcode.bin' ...
vfat(boot.vfat): adding file 'rpi-firmware/cmdline.txt' as 'rpi-firmware/cmdline.txt' ...
vfat(boot.vfat): adding file 'rpi-firmware/config.txt' as 'rpi-firmware/config.txt' ...
vfat(boot.vfat): adding file 'rpi-firmware/fixup.dat' as 'rpi-firmware/fixup.dat' ...
vfat(boot.vfat): adding file 'rpi-firmware/start.elf' as 'rpi-firmware/start.elf' ...
vfat(boot.vfat): adding file 'Image' as 'Image' ...
hdimage(sdcard.img): adding partition 'boot' (in MBR) from 'boot.vfat' ...
hdimage(sdcard.img): adding partition 'rootfs' (in MBR) from 'rootfs.ext4' ...
hdimage(sdcard.img): writing MBR
```


Les fichiers de sorties se trouvent dans le dossier "output"
Voici l'architecture de ce dossier :

| Dossier       |  Rôle           |   
| ------------- | -------------   |
| build         |  Sources et résultats de la compilation (exécutables et librairies) des différents programmes |
| host          |  Programmes nécessaires pour effectuer la cross compilation        |
| images        |  Fichiers à destination de         |
| stagging      |  |
| target        |         |

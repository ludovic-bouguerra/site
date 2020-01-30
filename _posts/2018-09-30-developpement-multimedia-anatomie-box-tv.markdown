---
layout: post
title:  "Développement multimédia - Anatomie d'une box TV"
date:   2018-09-30 19:30:00 +0200
categories: box tv multimédia freebox
long_description: Cet article présente l'architecture matérielle d'une box télévision, nous verrons également les utilitaires qui sont utilisés pour générer une distribution.
thumbnail: /images/posts/developpement-multimedia-anatomie-box-tv/thumbnail.png

---

Dans cet article je vais faire une rapide synthèse présentant l'architecture d'une box télévision. La première partie présentera l'architecture matérielle ensuite nous verrons quels outils sont utilisés pour générer les systèmes d'exploitations.

## Architecture matérielle

L'architecture matérielle diffère peu entre les différents fabricants. Les modèles de puces sont choisis en fonction de la politique d'entreprise et technologique. Les concepts resteront donc identiques.

Les circuits imprimés des set top box sont similaire à celui présenté ci dessous :   

![](/images/posts/developpement-multimedia-anatomie-box-tv/board.png){: style="text-align: center;"}

La première fonction commune à tout système éléctronique, la source d'alimentation. La partie **voltage regulators** regroupe les systèmes permettant d'adapter les tensions selon la documentation de chaque composant.

Ensuite on y trouve le **SOC**, System On Chip il s'agit de l'élément principal du système il assure le rôle d'un processeur offrant des fonctionnalités supplémentaires parmi lesquelles on retrouve :
- une partie dédiée au traitement vidéo et multimédia, elle permet l'encodage et le décodage d'un flux H264 sans ajouter de charge supplémentaire au processeur.
- une partie radio/communication, offrant la possibilité de se connecter / d'être hotspot WIFI, de communiquer en bluetooth.

La plus-part des SOC sont basées sur des architecture ARM pour la partie computing bien qu'Intel tente de se mettre sur ce marché. (Le Freebox player est par exemple équipé d'une Intel Atom source: [Wikipedia](https://fr.wikipedia.org/wiki/Freebox)). Parmi les constructeurs on trouve : Broadcom, Realtek, Intel, ST.

Elles sont également équipées d'un **Tuner TV** il s'agit d'une carte permettant de récupérer un signal provenant d'une fréquence donnée. Elles servent à recevoir le signal sattelite (DVB-S), terrestre (DVB-T) ou cable (DVB-C) en fonction du rôle du décodeur. Ils sont connectés soit via le bus USB soit PCI. Les tuners TV sont administrables, sous linux avec l'API Video4Linux.

Enfin deux composants permettent l'intégration du système avec une télévision et un réseau local. Le premier est un **transmetteur HDMI** il permet de transmettre les images en respectant le protocole HDMI. Et un **Ethernet PHY** qui permet de s'occuper de la partie transmission / réception des données sur le réseau. Il assure la partie physique de la transmission, le reste étant assuré par le SOC.

## Système d'exploitation

La majeure partie du temps il s'agit d'une distribution Linux. Plus récemment les systèmes intègrent Android TV.

[AOSP](https://source.android.com/) : Android Open Source Project, Il s'agit du système permettant de fabriquer l'image Android.

[Yocto](https://www.yoctoproject.org/) est un système permettant de générer une distribution Linux complète. Très complet, et très structuré il permet au détriment d'une prise en main un peu plus longue que Buildroot de générer un système avec gestion des paquets (ou non) pour de nombreuses cibles.

[Buildroot](https://www.buildroot.org/)  est un système permettant de générer une distribution Linux  plus simple d'accès que Yocto, il est toutefois plus limité.  

## Développement du logiciel

Pour la mise en place de l'acquisition vidéo, le décodage H264, la sélection du canal sur le tunner, le picture in picture. Le framework multimédia open source  [Gstreamer](https://gstreamer.freedesktop.org/) est souvent utilisé. Disponible aussi bien sur de nombreuses architectures et bénéficiant d'une grande communauté il permet 

---
layout: post
title:  "Présentation de Proxmox"
date:   2012-11-13 21:25:00 +0200
categories: virtualisation proxmox
long_description: "Proxmox est une distribution Linux basée sur Debian. C'est un serveur de virtualisation open source et gratuit. Il est d'utilisation et propose une administration depuis une interface Web, via une API ou plus classiquement en mode console."
redirect_from: ""

---
Proxmox est une distribution Linux basée sur Debian. C'est un serveur de virtualisation open source et gratuit. Il est d'utilisation et propose une administration depuis une interface Web, via une API ou plus classiquement en mode console.

Il offre un avantage par rapport a la concurrence (VMWare, Hyper-V) il permet de faire de la virtualisation par isolation. A l'opposé de la virtualisation matérielle qui comme son nom l'indique virtualise un ordinateur au complet (Processeur, mémoire, ...). La virtualisation par isolation permet de ne pas virtualiser le matériel et utilise le même noyau linux que l'hyperviseur.

A l'image de tous les autres outils il est également possible de faire de clustering c'est à dire qu'il est possible de centraliser et controller plusieurs instance de Proxmox depuis l'ensemble des serveurs appartenants à ce cluster.

Les avantages d'un cluster sont de pouvoir  :
<ul>
	<li>avoir un système avec une haute disponiblité (Synchronisation de machines virtuelle sur les différents clusters).</li>
	<li>faire des migrations de machines virtuelles très simplement (En moins de 2 clics et sans perte de disponibilité du service !).</li>
</ul>
Vous trouverez prochainement plus d'informations sur l'administration de cet outil et des exemples concrets d'utilisation.

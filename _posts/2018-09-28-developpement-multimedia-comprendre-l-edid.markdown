---
layout: post
title:  "Développement multimédia - Comprendre l'EDID"
date:   2018-09-28 19:30:00 +0200
categories: edid multimédia
long_description: Cet article présente l'EDID qui est  
thumbnail: /images/posts/developpement-multimedia-comprendre-l-edid/thumbnail.png

---


L'EDID permet à un dispositif de capture d'informer de ses capacités en terme de résolution, de profondeur de couleurs et de fréquence d'images et dans certains cas si il est possible d'envoyer de l'audio. Il permet aux cartes graphiques d'envoyer les images dans un format compréhensible pour la télévision / l'écran / la carte d'acquisition.

## Comment accéder à l'EDID ?

L'Edid est en général stocké dans une mémoire ROM accessible par le protocole I2C, on le trouve entre autre sur les ports HDMI, et VGA.


![](/images/posts/developpement-multimedia-comprendre-l-edid/vga.png)


En vga, l'EDID est accessible sur les PINS :

Les pins 9, 10, 12, 15 servent à l'alimentation de la mémoire réservée à EDID
et à la circulation de l'information.

![](/images/posts/developpement-multimedia-comprendre-l-edid/hdmi.png)

Les pins 15, 16, 17, 18, 19 servent à la transmission de l'EDID.

Principe de fonctionnement :

1 - Hotplug +5V
2 - Le périphérique demande l'EDID de l'écran
3 - Lecture de l'EDID
4 - Envoi d'une image corrspondante au bon format avec potentiellement du son.

## Structure de données

En fonction de la version l'EDID définie une structure de donnée qui contient soit 128 octets ou 256, nous étudierons la version 1.4 qui reste la plus utilisée a ce jour.

Elle est composée des éléments suivants :

- Header Informations
- Basic Display Parameters
- Chromaticity coordinates
- Established timing bitmap
- Standard timing information

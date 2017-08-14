---
layout: post
title:  "Extraire une portion de vidéo avec FFmpeg"
date:   2012-11-17 14:46:00 +0200
categories: ffmpeg vidéo
long_description: "Si vous souhaitez extraire une portion de vidéo (ou de son) cela est possible et très simple avec FFmpeg !"
redirect_from: ""
---
Si vous souhaitez extraire une portion de vidéo (ou de son) cela est possible et très simple avec FFmpeg !
Voici le code :
{% highlight shell %}
ffmpeg -ss débutdelaportion -t durée -i fichierSource fichierDestination
{% endhighlight %}

Plus concrètement l'exemple suivant exemple va extraire au sein de la vidéo test.avi la portion qui <strong>débute</strong> à 3 minutes 28 secondes et qui se termine 2 minutes 10 plus tard.

{% highlight shell %}
ffmpeg -ss 00:03:28.00 -t 00:02:10:00 -i test.avi extrait-test.avi
{% endhighlight %}


Certaines personnes on pu rencontrer des problèmes avec les Fichiers FLV, pour cela convertissez les d'abord en avi, mov ou mp4 pour faire en sorte que l'extraction se fasse parfaitement.

Pour faire cette conversion rien de plus simple :
{% highlight shell %}
ffmpeg -i test.flv test.mp4
{% endhighlight %}
Cette commande convertit le fichier test.flv en test.mp4

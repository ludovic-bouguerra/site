---
layout: post
title:  "Inside Docker : comprendre Docker en créant son propre mini système de container - partie 2 - Isolation des processus."
date:   2018-09-12 13:00:00 +0200
categories: docker chroot linux kernel namespace
long_description: Dans cette série de tutoriaux nous mettrons en place un mini système de container dans le but de comprendre comment fonctionne Docker.
thumbnail: /images/posts/comprendre-docker-en-creant-son-propre-mini-systeme-de-container-p1/thumbnail.jpeg
---

Dans mon premier article nous avons vu comment utiliser chroot pour isoler nos fichiers, toutefois pour "imiter" le comportement de Docker nous allons aussi avoir besoin d'isoler les processus.

Pour ce deuxième tutoriel vous devez avoir le dossier rootfs disponible comme présenté lors de la première partie.

Nous allons utiliser une fonctionnalité du noyau Linux les namespaces. Unshare est un programme qui utilise les api du noyau permettant de créer un namespace.

Notre but est que la commande suivante, affiche dans notre chroot uniquement les processus appartenant à notre nouvel espace et non pas l'ensemble des processus lancés par la machine.

```
ps -aux
```

Grâce à la commande suivante nous allons pouvoir créer nouvel espace virtuel où les processus parents ne seront pas visibles, nous ne pourrons pas interagir avec eux (envoi de signal par exemple.)

```
sudo unshare -pf chroot rootfs /bin/sh
```

Nous pouvons le confirmer par la commande suivante :

```
mount -t proc proc /proc
ps -aux
```

Le résultat retourné est le suivant

```
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   4340   764 ?        S    19:56   0:00 /bin/sh
root         6  0.0  0.0  17504  2128 ?        R+   19:56   0:00 ps -aux
```

Nous constatons que le pid 1 qui est sur le le système le processus /init ou /sbin/init ne l'est plus qu'il s'agit du nouveau processus que nous avons lancés avec chroot.

Essayons d'effacer un processus par exemple le 5996 qui était en cours d’exécution sur ma machine à ce moment là.

```
kill 5996
/bin/sh: 4: kill: No such process
```

En consultant dans un autre terminal la liste des processus nous voyons que les identifiants sont différents mais que les processus sont biens listés :

```
root     18851  0.1  0.0  54884  3832 pts/18   S    21:12   0:00 sudo unshare -pf chroot rootfs /bin/sh
root     18852  0.0  0.0   7296   688 pts/18   S    21:12   0:00 unshare -pf chroot rootfs /bin/sh
root     18853  0.0  0.0   4340   684 pts/18   S+   21:12   0:00 /bin/sh
```

Nous pouvons en faisant un kill 18853 constater que "l'hôte" a bien le contrôle.

Les namespaces linux permettent également d'isoler les connexions réseaux, les points de montages...

Code source d'unshare disponible ici : https://github.com/karelzak/util-linux/blob/master/sys-utils/unshare.c

Code source des "namespaces pid" : https://github.com/torvalds/linux/blob/2ce079f04d5914dae14fdc8618f804cc0d2a1b8f/kernel/pid_namespace.c

Le prochain article présentera comment isoler les interfaces réseaux.

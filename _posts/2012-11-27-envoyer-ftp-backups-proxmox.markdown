---
layout: post
title:  "Envoyer par FTP les backups réalisés par Proxmox"
date:   2012-11-27 21:44:00 +0200
categories: jekyll update
---
Voici un script qui pourrait vous être très utile et qui vous permettra d'envoyer sur un serveur ftp (dans mon cas les serveurs ftp backups d'OVH) les sauvegardes automatiques des machines virtuelles faites par Proxmox.

<strong>Prérequis</strong> : Vous devez faire des sauvegardes quotidiennes de vos machines virtuelles.

Ce script supprime les sauvegardes datant de plus de 2 jours sur le serveur.

A la fin de son execution il envoie un mail à l'administrateur pour lui informer de la bonne exécution de l'opération.

Créez un fichier sauvegarde.sh dans le dossier root avec le code suivant :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
#!/bin/bash
# ##################################################################
# # Script de sauvegarde
# ##################################################################

#hote FTP
FTP_SERVER=&quot;HOTE FTP&quot;
#login FTP
FTP_LOGIN=&quot;LOGIN&quot;
#pass FTP
FTP_PASS=&quot;motdepasse&quot;

MAIL_ADMIN=&quot;moi@test.com&quot;

#Dossier à sauvergarder
DIR_DUMP=&quot;/vz/dump/&quot;

##############################################
#
##############################################

DATE_FORMAT=&quot;$(date +%Y_%m_%d)&quot;
JOUR_DE_LA_SEMAINE_2_JOURS_AVANT=&quot;$(date --date=&#039;2 days ago&#039; +%w)&quot;

cd $DIR_DUMP

echo &quot;Suppression des données 2 jours avant ...&quot;
DATE_2_JOURS_AVANT=$(date --date=&#039;2 days ago&#039; +%Y_%m_%d)
/usr/bin/ftp -n -i $FTP_SERVER &lt;&lt;END
user $FTP_LOGIN $FTP_PASS
binary
cd $DATE_2_JOURS_AVANT
mdelete *.tar.lzo
cd ..
rmdir $DATE_2_JOURS_AVANT
quit
END

echo &quot;Connexion au serveur FTP et envoi des données&quot;
/usr/bin/ftp -n -i $FTP_SERVER &lt;&lt;END
user $FTP_LOGIN $FTP_PASS
binary
mkdir $DATE_FORMAT
cd $DATE_FORMAT
mput vzdump-openvz-*-2012_11_19-*.tar.lzo
quit
END

echo &quot;Effectuée avec succès.&quot; | mail -s &quot;Sauvegarde automatique du serveur $FTP_LOGIN du $DATE_FORMAT&quot; $MAIL_ADMIN

echo &quot;Fin de la mise en ligne ...&quot;
</pre>

<strong>Note importante</strong> : Le dossier dump correspond à l'emplacement où sont stockés les sauvegardes des machines.

Après avoir enregistré ce script vous devez ajouter un tâche cron afin que le script soit exécuté quotidiennement.
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
crontab -e
</pre>
Ajoutez la ligne suivante afin que le script s'exécute tous les jours à 7h du matin.
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
0 7 * * * /root/sauvegarde.sh &gt;/dev/null 2&gt;&amp;1
</pre>

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
{% highlight shell %}
#!/bin/bash
# ##################################################################
# # Script de sauvegarde
# ##################################################################

#hote FTP
FTP_SERVER="HOTE FTP"
#login FTP
FTP_LOGIN="LOGIN"
#pass FTP
FTP_PASS="motdepasse"

MAIL_ADMIN="moi@test.com"

#Dossier à sauvergarder
DIR_DUMP="/vz/dump/"

##############################################
#
##############################################

DATE_FORMAT="$(date +%Y_%m_%d)"
JOUR_DE_LA_SEMAINE_2_JOURS_AVANT="$(date --date=&#039;2 days ago&#039; +%w)"

cd $DIR_DUMP

echo "Suppression des données 2 jours avant ..."
DATE_2_JOURS_AVANT=$(date --date=&#039;2 days ago&#039; +%Y_%m_%d)
/usr/bin/ftp -n -i $FTP_SERVER <<END
user $FTP_LOGIN $FTP_PASS
binary
cd $DATE_2_JOURS_AVANT
mdelete *.tar.lzo
cd ..
rmdir $DATE_2_JOURS_AVANT
quit
END

echo "Connexion au serveur FTP et envoi des données"
/usr/bin/ftp -n -i $FTP_SERVER <<END
user $FTP_LOGIN $FTP_PASS
binary
mkdir $DATE_FORMAT
cd $DATE_FORMAT
mput vzdump-openvz-*-2012_11_19-*.tar.lzo
quit
END

echo "Effectuée avec succès." | mail -s "Sauvegarde automatique du serveur $FTP_LOGIN du $DATE_FORMAT" $MAIL_ADMIN

echo "Fin de la mise en ligne ..."
{% endhighlight %}

<strong>Note importante</strong> : Le dossier dump correspond à l'emplacement où sont stockés les sauvegardes des machines.

Après avoir enregistré ce script vous devez ajouter un tâche cron afin que le script soit exécuté quotidiennement.
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
crontab -e
</pre>
Ajoutez la ligne suivante afin que le script s'exécute tous les jours à 7h du matin.
{% highlight shell %}
0 7 * * * /root/sauvegarde.sh >/dev/null 2>&1
{% endhighlight %}

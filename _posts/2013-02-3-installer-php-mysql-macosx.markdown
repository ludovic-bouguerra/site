---
layout: post
title:  "Installer PHP et Mysql sur Mac OS X"
date:   2013-02-03 20:42:0 +0200
categories: macosX php mysql
long_description: "Par défaut MAC OS X est livré avec Apache et PHP mais il ne sont pas configurés. Dans ce tutoriel nous allons paramétrer notre environnement afin de pouvoir développer et tester nos site depuis un MAC."

---
Par défaut MAC OS X est livré avec Apache et PHP mais il ne sont pas configurés. Dans ce tutoriel nous allons paramétrer notre environnement afin de pouvoir développer et tester nos site depuis un MAC.

Dans un premier temps il faut éditer le fichier de configuration d'Apache qui se trouve dans <strong>/private/etc/apache2/httpd.conf</strong>.
Pour cela il est nécessaire d'avoir les droits d'administration. Ouvrons un terminal (Applications > Utilitaires > Terminal) et lançons les commandes suivantes :
Faisons dans un premier temps une copie du fichier de configuration original.
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
sudo cp /private/etc/apache2/httpd.conf /private/etc/apache2/httpd.conf.original
</pre>
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
sudo nano /private/etc/apache2/httpd.conf
</pre>
Cette commande va ouvrir un éditeur de texte en mode administrateur. (Vous devrez entrer votre mot de passe).

Faites une recherche (en pressant ctrl + w) avec comme mot clé : php5_module. La recherche devrait vous amener à la ligne suivante :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
#LoadModule php5_module        libexec/apache2/libphp5.so
</pre>
Décommentez cette ligne en enlevant le #.

Vous pouvez a présent quitter votre éditeur de texte (ctrl + x) et confirmer que vous voulez bien sauvegarder ce fichier en répondant "y" à la question.

A présent il faut redémarrer Apache pour que les modifications soient prises en compte :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">sudo apachectl graceful</pre>

Rendez vous dans votre dossier ~/Sites/ créez un fichier test.php avec comme contenu
<pre class="brush: php; gutter: true; first-line: 1; highlight: []; html-script: false">
&lt;?php phpinfo(); ?&gt;
</pre>

Rendez vous à la page : http://localhost/~VotreNom/test.php, si tout s'est bien passé vous devrez avoir une page avec de ce type :
<img src="http://www.ludovicbouguerra.fr/wp-content/uploads/2013/02/installer-php-macosx-1.png" />

A présent il faut installer Mysql :
http://dev.mysql.com/downloads/mysql/

Prenez la version qui correspond à votre Système d'exploitation (32 ou 64 bits).
<img src="/images/posts/installer-php-et-mysql-sur-mac-os-x/installer-php-macosx-2.png" />
Installez les deux fichiers pkg : mysql-5.5.29-osx10.6-x86_64.pkg et MySQLStartupItem.pkg

Puis executer le fichier MySQL.prefPane qui va vous permettre de controller le démarrage de Mysql dans les Préférences Système Mac OS X.

Vous pouvez à présent controller l'exécution de Mysql au sein de vos Préférences Système :
<img src="/images/posts/installer-php-et-mysql-sur-mac-os-x/installer-php-macosx-3.png" />

<img src="/images/posts/installer-php-et-mysql-sur-mac-os-x/installer-php-macosx-4.png" />

Enfin attribuons un mot de passe à votre utilisateur root exécutez la commande suivante :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
/usr/local/mysql/bin/mysqladmin -u root password &#039;nouveauMotDePasseRoot&#039;
</pre>

Enfin arrêtez Mysql, (Préférences Systèmes > Mysql > Arrêter)
Créez le fichier suivant /etc/my.cnf, nous indiquons à Mysql ou est ce qu'il doit stocker les fichiers qui seront utilisés par entre autres les clients (PHP, ...) .
Ouvrons un éditeur de texte en administrateur.
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
sudo nano /etc/my.cnf
</pre>
Et copions le contenu suivant :
<pre>
[client]
socket = /var/mysql/mysql.sock

[mysqld]
socket = /var/mysql/mysql.sock
</pre>

Redémarrez Mysql et PHP, tout devrait fonctionner.

A présent si vous souhaitez configurer mysql depuis votre navigateur vous pouvez installer PhpMyAdmin disponible ici :
http://www.phpmyadmin.net/home_page/downloads.php

Copiez le dossier que vous venez de télécharger dans le dossier
/Library/Webserver/Documents/ en le nommant phpmyadmin.

Dans ce dossier copier le fichier de configuration par défaut config.sample.inc.php en le renommant en config.inc.php.

Rendez-vous sur http://localhost/phpmyadmin/ et vous pouvez après avoir entré vos identifiants root administrer votre base de donnée.

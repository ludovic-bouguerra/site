---
layout: post
title:  "Installer OpenERP - Odoo sur Debian"
date:   2013-04-19 20:32:00 +0200
categories: openerp odoo debian
---
<h1>Qu'est ce qu'OpenERP ?</h1>
OpenERP est un logiciel qui permet de centraliser la gestion de son entreprise (Comptabilité, Ressources Humaines, ...) au sein d'un même outil. Libre et Gratuit il est installable sur n'importe quelle distribution Linux et même sur Mac OSX et Windows.

La version 7 de cet outil apporte une plus grande <strong>simplicité d'utilisation</strong> ce qui le rend plus attractif pour les PME et TPE.

Il existe une importante communauté autour de ce logiciel ce qui fait que les mises à jours sont fréquentes et qu'en cas de questions vous obtiendrez des réponses assez rapidement.
<h1>Quand dois-je installer un ERP ?</h1>
OpenERP met a disposition un service SAAS ce qui vous permet d'avoir l'outil en ligne et hébérgé sur les serveurs d'OpenErp qui se chargeront des mises à jours des sauvegardes ... Si vous n'avez pas confiance au cloud, que vous avez une équipe d'informaticiens doués et qui ont du temps de libre. Vous pourrez sans problème installer cet outil en interne au sein de votre entreprise. Vous aurez : - Une maitrise de vos données.

Par contre vous devrez :
<ul>
	<li>Assurer la maintenance de l'outil.</li>
	<li>Le configurer.</li>
	<li>Avoir à disposition un serveur.</li>
</ul>
Prérequis.
<ul>
	<li>Il faut avoir un serveur PostgreSql Installé.</li>
</ul>
A l'heure ou j'écris cet article, la version 7 est passée en version stable mais il y a encore de petits bugs (mais non contraignants). La traduction Française n'est pas encore parfaite (il doit y avoir 80% des phrases traduites).

Première étape installation de PostgreSQL.
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">apt-get install postgresql
</pre>
<strong>Important :</strong> un ERP c'est le coeur du système d'information de l'entreprise. Pour un système en production il faut absoluement prévoir une redondance de la base de donnée (et du logiciel openerp) afin d'assurer une continuité de service. Il faut aussi penser à effectuer des sauvegardes régulières de votre base de donnée afin de pouvoir en cas de problème restaurer au plus vite votre système.

Afin de faire les choses proprements nous allons devoir :

Important : Votre installation de PostgreSQL doit accepter l'encodage UTF-8
<strong>A effectuer uniquement sur des bases de données qui ne sont pas en production !</strong>
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">pg_dropcluster --stop 8.4 main
pg_createcluster --start -e UTF-8 8.4 main
</pre>
Création d'un utilisateur OPENERP et d'une base de donnée OPENERP
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">su - postgres
psql
CREATE ROLE openerp WITH ENCRYPTED PASSWORD &#039;123456&#039; LOGIN;
CREATE DATABASE openerp WITH OWNER openerp;
\q
exit
</pre>
Seconde étape installation d'OpenErp.

Ajoutons dans le fichiers sources.list (/etc/apt/sources.list)
les lignes suivantes :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">deb http://nightly.openerp.com/7.0/nightly/deb/ ./
</pre>
Puis lancer :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">sudo apt-get update
sudo apt-get install openerp
</pre>
Arrêtons openerp qui s'est lancé automatiquement :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">/etc/init.d/openerp stop
</pre>
Modifiez le fichier en remplissant les informations sur votre base de donnée :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">nano /etc/openerp-server/openerp-server.conf
</pre>
<pre>; This is the password that allows database operations:
; admin_passwd = admin
db_host = 10.0.0.11
db_port = 5432
db_user = openerp
db_password = 123456
db_name = openerp
without_demo = all
</pre>
Relançons openerp :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">/etc/init.d/openerp start
</pre>
Il faut à présenter se connecter sur l'interface d'administration.

http://[AdresseIPdeVotreServeur]:8069

A l'invite suivante :
<img style="max-width: 500px;" src="http://www.ludovicbouguerra.fr/wp-content/uploads/2013/04/Capture-d’écran-2013-04-19-à-21.33.53.png" alt="Invite mot de passes OpenERP" />

Entrez l'utilisateur et le mot de passe par défaut d'OpenERP : admin / admin.

A présent il va falloir sélectionner les modules qui vous intéressent.

<img style="max-width: 500px;" src="http://www.ludovicbouguerra.fr/wp-content/uploads/2013/04/Capture-d’écran-2013-04-19-à-21.33.38.png" alt="Sélection des modules OpenERP" />

Création du proxy HTTP :
[ Prochainement ]

En ce qui concerne la maintenance (Mises à Jours) et la configuration comment cela se passe ?

La maintenance est faite par les équipes d'OpenERP et mise à disposition de la communauté. Tous les mois les nouvelles mises à jour sont disponibles et vous pouvez depuis l'interface faire cette mise à jour. Il faut veiller à mettre à jour régulièrement l'ERP afin d'éviter de laisser des failles de sécurités.
Deuxième point concernant la maintenance pensez à faire des backups réguliers de vos bases de données et des données que l'ERP enregistres (Fichiers uploadés par les utilisateurs ...). Bien que cet outil soit stable vous n'êtes jamais à l'abri de problèmes soit au niveau de votre serveur soit au niveau logiciel.
Enfin en ce qui concerne la configuration, de base OpenERP fourni de nombreux modules qui permettent de gérer les tâches de gestions courante de l'Entreprises. Il se peut également que vous ayez des besoins très précis par exemple :

- Connecter l'ERP à votre logiciel de commande en ligne. (Synchronisation des clients, des paiements ...).

<em id="__mceDel">- ...</em>

<em id="__mceDel"><em id="__mceDel"> Pour cela vous devez dans un premier temps vérifier qu'il n'existe pas d'outil équivalent ou qui s'y rapproche sur internet. Le cas écheants dévelloper un plugin pour OpenERP n'est pas si difficile si vous avez une équipe d'informaticiens à disposition (et qu'ils ont du temps de libre (le Week End, ou le Soir :) ) il n'auront pas trop de difficultés à s'adapter sachant que la documentation est très bien faite.</em></em>

Prochainement je mettrai en ligne une documentation pour mettre à jour et configurer l'ERP. Pendant ce temps essayez de le découvrir.

Si vous avez besoin de renseignements vous pouvez me contacter.

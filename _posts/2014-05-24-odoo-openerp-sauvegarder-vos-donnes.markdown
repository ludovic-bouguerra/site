---
layout: post
title:  "Odoo - OpenERP : Sauvegarder vos données"
date:   2014-05-24 18:56:00 +0200
categories: openerp odoo
long_description: "OpenERP permet de réaliser simplement la sauvegarde de vos données pour pouvoir : les restaurer en cas de problèmes, les utiliser sur une version de pré-production pour tester une modification."
---
OpenERP permet de réaliser simplement la sauvegarde de vos données pour pouvoir :

- les restaurer en cas de problèmes

- les utiliser sur une version de pré-production pour tester une modification.

<h2>La sauvegarde des données</h2>

Ce dont nous aurons besoin pour effectuer ce tutoriel :

- Une version d'OpenERP - Odoo configurée et installée.

-Le mot de passe d'administrateur d'OpenERP - Odoo.

<a href="/images/posts/odoo-openerp-sauvegarder-donnes/OpenERP-ecran-de-connexion.png"><img class="aligncenter wp-image-580 size-large" src="/images/posts/odoo-openerp-sauvegarder-donnes/OpenERP-ecran-de-connexion-1024x574.png" alt="OpenERP écran de connexion" width="1024" height="574" /></a>

Nous allons entrer dans le backoffice de gestion des bases de données d'OpenERP. Pour cela Cliquez sur le lien "Gestion des bases de données". <a href="/images/posts/odoo-openerp-sauvegarder-donnes/backoffice-openerp-odoo.png"><img class="aligncenter wp-image-582 size-large" src="/images/posts/odoo-openerp-sauvegarder-donnes/backoffice-openerp-odoo-1024x438.png" alt="backoffice-openerp-odoo" width="1024" height="438" /></a>

Se rendre dans le menu Archiver puis sélectionnez la base de données que vous souhaitez sauvegarder, saisissez le mot de passe administrateur d'OpenERP. Enfin cliquez sur "Archiver". Si tout ce passe bien votre navigateur téléchargera un fichier "dump" contenant l'ensemble des données présentes dans votre base.

Important : Nous vous conseillons de tester de votre sauvegarde et de ne jamais faire confiance aux systèmes de sauvegardes il faut régulièrement tester vos sauvegardes !
<h2>La restauration des données.</h2>
Nous allons à présent restaurer nos données pour cela, rendez vous dans le menu restaurer, sélectionnez le fichier que vous souhaitez restaurer, donnez un nom à votre base de donnée et saisissez le mot de passe administrateur d'OpenERP.

<a href="/images/posts/odoo-openerp-sauvegarder-donnes/backoffice-openerp-odoo-restaurer.png"><img class="aligncenter size-large wp-image-583" src="/images/posts/odoo-openerp-sauvegarder-donnes/backoffice-openerp-odoo-restaurer-1024x232.png" alt="backoffice-openerp-odoo-restaurer" width="1024" height="232" /></a>

&nbsp;
<h2>En cas de problèmes</h2>
Vérifiez que avez la même version du système de base de donnée installé avec la même configuration, notamment sur les paramètres de localisation et d'encodage. Si sur votre environnement de production l'encodage est en UTF-8 et les paramètres de localisation sont FR_fr, les données ne pourront pas être restaurées sur un environnement en_US.

---
layout: post
title:  "Intégrez Redmine dans Eclipse afin d’assurer le suivi de vos tâches"
date:   2013-09-01 14:46:00 +0200
categories: redmine taches
long_description: "Redmine propose des outils intéressants pour la gestion de projet informatique. Néanmoins remplir les tâches effectuées au quotidien depuis l’interface Web s’avère fastidieux. Il est possible d’intégrer le suivi des taches Redmine au sein d’Eclipse (Et même Netbeans)."
redirect_from: "/2013/09/integrez-redmine-dans-eclipse-afin-dassurer-le-suivi-vos-taches/"
---
Redmine propose des outils intéressants pour la gestion de projet informatique. Néanmoins remplir les tâches effectuées au quotidien depuis l’interface Web s’avère fastidieux. Il est possible d’intégrer le suivi des taches Redmine au sein d’Eclipse (Et même Netbeans).

Prérequis :

Redmine 2.0 ou plus d’installé.
Avoir une version d’Eclipse.
L’intégration se fera en deux étapes, dans un premier temps nous allons installer un plugin pour Redmine qui fera office de connecteur pour pouvoir récupérer les informations. Par la suite nous installerons un plugin pour Eclipse pour qu’il communique avec Redmine.

Rendez-vous dans le dossier plugin de votre installation de Redmine.

git clone git://redmin-mylyncon.git.sourceforge.net/gitroot/redmin-mylyncon/redmine-mylyn-connector
Redémarrez Redmine et vérifiez que dans l’onglet plugins de l’espace administration votre plugin soit bien référencé :

<img src="/images/posts/integrez-redmine-dans-eclipse-afin-dassurer-le-suivi-vos-taches/redmine-integration-eclipse-1.png" />

Avant de finir avec Redmine il faut activer l’API REST.

<img src="/images/posts/integrez-redmine-dans-eclipse-afin-dassurer-le-suivi-vos-taches/redmine-integration-eclipse-2.png" />

Administration / Configuration / Authentification / Cocher Activer Api Rest

A présent il faut installer le connecteur coté Eclipse. Pour cela il faut se rendre dans le menu Help – Install New Software.

<img src="/images/posts/integrez-redmine-dans-eclipse-afin-dassurer-le-suivi-vos-taches/redmine-integration-eclipse-3.png"/>

Puis ajouter le site suivant dans le champs work with :

http://redmin-mylyncon.sourceforge.net/update-site/N/

<img src="/images/posts/integrez-redmine-dans-eclipse-afin-dassurer-le-suivi-vos-taches/redmine-integration-eclipse-4.png" />

Enfin cochez « Mylyn integration » et laissez vous guider.

Maintenant il nous suffit d’ajouter un repository.
<img src="/images/posts/integrez-redmine-dans-eclipse-afin-dassurer-le-suivi-vos-taches/redmine-integration-eclipse-5.png" />

Remplissez les informations sur votre serveur et vos identifiants pour vous connecter à Redmine.

<img src="/images/posts/integrez-redmine-dans-eclipse-afin-dassurer-le-suivi-vos-taches/redmine-integration-eclipse-6.png" />


Vous êtes à présent prêt pour utiliser Redmine

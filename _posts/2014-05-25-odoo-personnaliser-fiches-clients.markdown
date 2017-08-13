---
layout: post
title:  "Odoo - OpenERP : Personnalisez vos fiches clients"
date:   2014-05-24 17:01:00 +0200
categories: openerp odoo
long_description: "La fiche client d'OpenERP peut s'avérer insuffisante si vous avez besoin de stocker des informations particulières sur vos clients. Typiquement si vous souhaitez enregistrer le Siret des entreprises vous pouvez l'enregistrer dans les notes internes. Néanmoins vous ne pourrez pas faire de recherche et puis les données seront moins structurées."
---
La fiche client d'OpenERP peut s'avérer insuffisante si vous avez besoin de stocker des informations particulières sur vos clients. Typiquement si vous souhaitez enregistrer le Siret des entreprises vous pouvez l'enregistrer dans les notes internes. Néanmoins vous ne pourrez pas faire de recherche et puis les données seront moins structurées.

[caption id="attachment_550" align="aligncenter" width="1024"]<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/openerp-fiche-client-basique.png"><img class="wp-image-550 size-large" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/openerp-fiche-client-basique-1024x597.png" alt="Fiche client basique" width="1024" height="597" /></a> Fiche client basique[/caption]

Quels droits sont nécessaires pour faire cette opération :
Pour ajouter un champ, il faut avoir les droits d'administration technique.
Par défaut l'administrateur n'a pas ces droits là. Pour les activer il faut se rendre dans le menu Configuration, Utilisateurs puis sélectionner l'utilisateur qui pourra faire cette manipulation.

<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/openerp-user-management.png"><img class="aligncenter wp-image-552 size-large" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/openerp-user-management.png" alt="openerp-user-management" width="1024" height="339" /></a>

Pour cette démonstration nous allons autoriser l'utilisateur "admin" à effectuer les opérations techniques.

[caption id="attachment_553" align="aligncenter" width="1024"]<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/openerp-utilisateur-caract-techniques.png"><img class="wp-image-553 size-large" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/openerp-utilisateur-caract-techniques.png" alt="OpenERP Utilisateur avec caractéristiques techniques." width="1024" height="577" /></a> OpenERP Utilisateur avec caractéristiques techniques.[/caption]

Il suffit de cocher la case "Caractéristiques techniques" que l'on trouve après avoir cliqué sur "Modifier" et "Droits d'accès". Ensuite il suffit de cliquer sur "Enregistrer".

Après avoir rafraîchit la page (cmd + R sous mac, F5 sous PC) vous verrez de nouveaux menus.

[caption id="attachment_554" align="aligncenter" width="427"]<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/menu-openerp-technique.png"><img class="wp-image-554 size-large" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/menu-openerp-technique.png" alt="OpenERP menu" width="427" height="1024" /></a> OpenERP menu[/caption]

Parmi les sous-menus du menu technique deux d'entre eux nous intéressent :
- Interface utilisateur.
- Structure de la base de donnée.

Le sous-menu interface utilisateur permet de modifier la façon dont s'affichent les différents formulaires d'OpenERP (Fiche client, Fiche article ...).

Le sous-menu Structure de la base de donnée permet de modifier le modèle de données. C'est ici que nous allons commencer. Nous allons ajouter un champs que nous appellerons SIRET et qui permettra de stocker comme son nom l'indique le SIRET de l'entreprise.
<h2>Ajout dans le modèle de données</h2>
<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/menu-technique-structure-bdd.png"><img class="aligncenter wp-image-557 size-full" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/menu-technique-structure-bdd.png" alt="menu-technique-structure-bdd" width="233" height="371" /></a>

Nous allons nous rendre dans le sous-menu "Modèles", l'ensemble des modèles d'OpenERP sont alors listés.
Pour avoir à éviter de parcourir l'ensemble des 144 modèles d'OpenERP nous allons faire une recherche avec le mot clé : "Partner".

<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/OpenERP-Recherche-Modele-Partner.png"><img class="aligncenter wp-image-558 size-large" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/OpenERP-Recherche-Modele-Partner.png" alt="OpenERP-Recherche-Modele-Partner" width="1024" height="422" /></a>

Le modèle partner regroupe à la fois les clients, les fournisseurs que ce soit des entreprise ou des personnes.

<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/OpenERP-detail-modele-partner.png"><img class="aligncenter wp-image-559 size-full" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/OpenERP-detail-modele-partner.png" alt="OpenERP-detail-modele-partner" width="988" height="882" /></a>

En cliquant sur Partner nous voyons le détails des champs existants, certains doivent vous paraître familiers. Pour ajouter un champs il faut cliquer sur "Modifier". Puis sur Ajouter un élément.

<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/OpenERP-detail-partner-modifier-ajouter.png"><img class="aligncenter wp-image-560 size-full" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/OpenERP-detail-partner-modifier-ajouter.png" alt="OpenERP-detail-partner-modifier-ajouter" width="909" height="203" /></a>

Nous allons maintenant pouvoir saisir les informations sur notre Champs SIRET.

<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/OpenERP-Ajouter-Champ-Partner.png"><img class="aligncenter wp-image-561 size-full" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/OpenERP-Ajouter-Champ-Partner.png" alt="OpenERP-Ajouter-Champ-Partner" width="908" height="683" /></a>

Remplissons à présent les informations :

<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/OpenERP-Valider-Modele.png"><img class="aligncenter wp-image-564 size-full" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/OpenERP-Valider-Modele.png" alt="OpenERP-Valider-Modele" width="890" height="633" /></a>

Le nom doit obligatoirement commencer par un "x_" afin de préciser que c'est un champ personnalisé. Nous allons l'appeler x_siret.

Libellé du champ : C'est un nom un peu plus parlant pour l'utilisateur. Ce sera SIRET.

Type de champ : C'est un type "Char" (Nombre de caractères limités).
Taille nous mettrons 14 car un SIRET comporte 14 chiffres.

Et nous allons autoriser la recherche. (Recherche possible : Recherche toujours possible).

Et nous pouvons Enregistrer et Fermer.

Puis cliquer sur Enregistrer pour sauvegarder le modèle partner.
<h2>Modification de la vue Partner</h2>
A présent le champ est présent dans le modèle de données mais il ne sera pas affiché. Pour qu'il soit affiché nous allons devoir modifier la vue "Partner".

<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/menu-vue-technique-openerp.png"><img class="aligncenter wp-image-566 size-full" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/menu-vue-technique-openerp.png" alt="menu-vue-technique-openerp" width="252" height="217" /></a>

Dans le sous-menu "Interface utilisateur" se rendre dans le menu Vues. De la même manière que pour les modèles de données nous allons chercher le mot clé Partner pour voir les vues qui sont associés au modèle de données "Partner".

<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/vue-modele-partner.png"><img class="aligncenter wp-image-567 size-large" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/vue-modele-partner.png" alt="vue-modele-partner" width="1024" height="795" /></a>

En cliquant sur le premier résultat on accède à la configuration de la vue Partner.
<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/modifier-vue-partner.png"><img class="aligncenter wp-image-568 size-full" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/modifier-vue-partner.png" alt="modifier-vue-partner" width="1005" height="899" /></a>

Sous OpenERP les vues sont générées à partir de fichiers XML. Nous allons donc devoir modifier le fichier XML, pour ajouter le champs SIRET.

[caption id="attachment_550" align="aligncenter" width="1024"]<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/openerp-fiche-client-basique.png"><img class="wp-image-550 size-large" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/openerp-fiche-client-basique-1024x597.png" alt="Fiche client basique" width="1024" height="597" /></a> Fiche client basique[/caption]

Nous allons ajouter ce champ après le Site WEB. Pour cela nous allons ajouter après cette ligne là
{% highlight bash %}
<field name="website" widget="url" placeholder="e.g. www.openerp.com"/>;
{% endhighlight %}

et avant celle-ci
{% highlight bash %}

</group>;

{% endhighlight %}
{% highlight bash %}
<field name="x_siret" widget="text" domain="[('is_company', '=', True)]" attrs="{'invisible': [('is_company','!=', True)]}"/>;

{% endhighlight %}

Quelques explications :
Avec cette ligne nous précisons que nous souhaitons afficher le champs "x_siret" (&lt;field name="x_siret") et qu'il soit visible uniquement si c'est une entreprise. ( attrs="{'invisible': [('is_company','!=', True)]}"/&gt;)

<a href="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/champ-siret-openerp.png"><img class="aligncenter wp-image-570 size-full" src="/images/posts/odoo-openerp-personnalisez-vos-fiches-clients/champ-siret-openerp.png" alt="champ-siret-openerp" width="931" height="444" /></a>

A présent si l'on va dans le menu Ventes / Clients, en créant un nouveau client et en cliquant sur "Est-ce une société ?" Notre champ Siret apparait.

Ajoutez un client, essayez de faire une recherche sur ce champ là et vous devriez retrouver votre client.

A présent vous pourrez facilement personnaliser / modifier Odoo (ex OpenERP) pour avoir des fiches clients à votre convenance.

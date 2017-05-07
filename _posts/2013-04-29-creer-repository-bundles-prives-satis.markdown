---
layout: post
title:  "Créer un repository de Bundles privés avec Satis"
date:   2013-04-29 21:25:00 +0200
categories: développement
---
Prérequis :
<ul>
	<li>Composer.phar</li>
</ul>

Satis est une application symfony qui fera le liens entre le noms de vos Bundles symfony, leurs versions et leurs dépots pour les télécharger.

Pour prendre un exemple simple, vous venez de créer un Bundle e-commerce pour votre entreprise. Après l'avoir référencé sur cet outil tous les développeurs pourront télécharger et avoir la dernière version sur leurs projets symfony avec composer.

Intérêts :
<ul>
- Mettre à disposition aux développeurs de votre entreprise des outils que vous utilisez souvent.
- Bénéficier de la puissance de composer sans déployer vos sources sur internet.
</ul>

Nous allons dans un premier temps installer satis sur le serveur qui assurera la centralisation des packages.
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
composer.phar create-project composer/satis --stability=dev
</pre>
La configuration de l'outil se fait à travers un fichier JSON que nous appellerons satis.json à la racine du repertoire.
{% highlight javascript %}
{
    "name": "MonEntreprise",
    "homepage": "https://packages.kalyzee.local",
    "repositories": [
        { "type": "svn", "url": "https://intranet.kalyzee.local/svn/test-2/" }
    ],
    "require-all": true
}

{% endhighlight %}

Notre repository est composé de deux projets en version 1.0.0 et leurs sources sont accessible dans la partie trunk. Vous pouvez utiliser SVN, Git ou d'autres outils; la condition est que chaque client que vous utilisez doit être installé sur les postes des développeurs.

Dans chaque repository cité il doit y avoir dans le trunk et / ou dans les branches et / ou dans les tags un fichier composer.json :

{% highlight javascript %}
{
    "name": "mon-entreprise/test-2",
    "description": "Test-2 bundle for Symfony 2",
    "keywords": ["Test","bundle"],
    "type": "symfony-bundle",
    "license": "Commercial",
    "authors": [
        {
            "name": "Ludovic Bouguerra",
            "email": "bouguerra.ludovic@gmail.com"
        }
    ],
    "require": {
        "symfony/framework-bundle": "2.*",
        "twig/twig": "1.*"
    },
    "autoload": {
        "psr-0": { "MonEntreprise\\Test2": "" }
    },
    "target-dir": "MonEntreprise/Test2"

}
{% endhighlight %}

Après avoir réalisé cela il faut lancer la commande suivante pour mettre à jour l'annuaire : (A effectuer à la racine de l'application satis ) :
{% highlight bash %}
php bin/satis build satis.json web/
{% endhighlight %}

Le resultat de cette analyse se trouvera donc dans le dossier web :
{% highlight bash %}
web/index.html -> Fichier présentant l&#039;annuaire des repositories disponibles pour les visiteurs.
web/packages.json -> Fichier json utilisé par composer.json
{% endhighlight %}


Lors de la première installation il faudra faire un virtualhost vers le dossier web de votre application symfony :

{% highlight bash %}
<VirtualHost *:80>
                ServerName packages.monentreprise.org

                DocumentRoot /home/ftp/org/monentreprise/packages/html/web
                ErrorLog     /home/ftp/org/monentreprise/packages/logs/errors.log

                <Directory />
                        Options FollowSymLinks
                        AllowOverride All
                </Directory>
                <Directory /home/ftp/org/monentreprise/packages/html/web>
                        Options Indexes FollowSymLinks MultiViews
                        AllowOverride All
                        Order allow,deny
                        allow from all
                </Directory>
</VirtualHost>
{% endhighlight %}

Cet outil est très interessant pour les entreprises qui développent leurs propre bundle

Utilisation dans votre application symfony :
en vous rendant à l'URL suivante vous aurez les instructions pour intégrer ce nouveau repository dans les fichiers composer.json de vos projets :
<pre>
http://packages.monentreprise.org/
</pre>

{% highlight javascript %}
{
    "repositories": [
        {
            "type": "composer",
            "url": "http://packages.monenetreprise.org"
        }
    ]
}
{% endhighlight  %}

A présent si vous souhaitez utiliser le bundle Test2 dans un nouveau projet il suffira d'ajouter :
{% highlight javascript %}
    "repositories": [
        {
            "type": "composer",
            "url": "http://packages.monentreprise.org"
        }
    ],
    "require": {
        [...]
        "mon-entreprise/test-2": "dev-trunk"
    },

{% endhighlight %}

En faisant :
{% highlight shell %}
php composer.phar update
{% endhighlight %}
Vous devriez pouvoir utiliser la dernière version de votre bundle Test2.

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
<pre class="brush: javascript; gutter: true; first-line: 1; highlight: []; html-script: false">
{
    &quot;name&quot;: &quot;MonEntreprise&quot;,
    &quot;homepage&quot;: &quot;https://packages.kalyzee.local&quot;,
    &quot;repositories&quot;: [
        { &quot;type&quot;: &quot;svn&quot;, &quot;url&quot;: &quot;https://intranet.kalyzee.local/svn/test-2/&quot; }
    ],
    &quot;require-all&quot;: true
}

</pre>

Notre repository est composé de deux projets en version 1.0.0 et leurs sources sont accessible dans la partie trunk. Vous pouvez utiliser SVN, Git ou d'autres outils; la condition est que chaque client que vous utilisez doit être installé sur les postes des développeurs.

Dans chaque repository cité il doit y avoir dans le trunk et / ou dans les branches et / ou dans les tags un fichier composer.json :

<pre class="brush: javascript; gutter: true; first-line: 1; highlight: []; html-script: false">
{
    &quot;name&quot;: &quot;mon-entreprise/test-2&quot;,
    &quot;description&quot;: &quot;Test-2 bundle for Symfony 2&quot;,
    &quot;keywords&quot;: [&quot;Test&quot;,&quot;bundle&quot;],
    &quot;type&quot;: &quot;symfony-bundle&quot;,
    &quot;license&quot;: &quot;Commercial&quot;,
    &quot;authors&quot;: [
        {
            &quot;name&quot;: &quot;Ludovic Bouguerra&quot;,
            &quot;email&quot;: &quot;bouguerra.ludovic@gmail.com&quot;
        }
    ],
    &quot;require&quot;: {
        &quot;symfony/framework-bundle&quot;: &quot;2.*&quot;,
        &quot;twig/twig&quot;: &quot;1.*&quot;
    },
    &quot;autoload&quot;: {
        &quot;psr-0&quot;: { &quot;MonEntreprise\\Test2&quot;: &quot;&quot; }
    },
    &quot;target-dir&quot;: &quot;MonEntreprise/Test2&quot;

}
</pre>

Après avoir réalisé cela il faut lancer la commande suivante pour mettre à jour l'annuaire : (A effectuer à la racine de l'application satis ) :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
php bin/satis build satis.json web/
</pre>

Le resultat de cette analyse se trouvera donc dans le dossier web :
<pre>
web/index.html -&gt; Fichier présentant l&#039;annuaire des repositories disponibles pour les visiteurs.
web/packages.json -&gt; Fichier json utilisé par composer.json
</pre>


Lors de la première installation il faudra faire un virtualhost vers le dossier web de votre application symfony :

<pre>
&lt;VirtualHost *:80&gt;
                ServerName packages.monentreprise.org

                DocumentRoot /home/ftp/org/monentreprise/packages/html/web
                ErrorLog     /home/ftp/org/monentreprise/packages/logs/errors.log

                &lt;Directory /&gt;
                        Options FollowSymLinks
                        AllowOverride All
                &lt;/Directory&gt;
                &lt;Directory /home/ftp/org/monentreprise/packages/html/web&gt;
                        Options Indexes FollowSymLinks MultiViews
                        AllowOverride All
                        Order allow,deny
                        allow from all
                &lt;/Directory&gt;
&lt;/VirtualHost&gt;
</pre>

Cet outil est très interessant pour les entreprises qui développent leurs propre bundle

Utilisation dans votre application symfony :
en vous rendant à l'URL suivante vous aurez les instructions pour intégrer ce nouveau repository dans les fichiers composer.json de vos projets :
<pre>
http://packages.monentreprise.org/
</pre>

<pre class="brush: javascript; gutter: true; first-line: 1; highlight: []; html-script: false">
{
    &quot;repositories&quot;: [
        {
            &quot;type&quot;: &quot;composer&quot;,
            &quot;url&quot;: &quot;http://packages.monenetreprise.org&quot;
        }
    ]
}
</pre>

A présent si vous souhaitez utiliser le bundle Test2 dans un nouveau projet il suffira d'ajouter :
<pre class="brush: javascript; gutter: true; first-line: 1; highlight: []; html-script: false">
    &quot;repositories&quot;: [
        {
            &quot;type&quot;: &quot;composer&quot;,
            &quot;url&quot;: &quot;http://packages.monentreprise.org&quot;
        }
    ],
    &quot;require&quot;: {
        [...]
        &quot;mon-entreprise/test-2&quot;: &quot;dev-trunk&quot;
    },

</pre>

En faisant :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
php composer.phar update
</pre>
Vous devriez pouvoir utiliser la dernière version de votre bundle Test2.

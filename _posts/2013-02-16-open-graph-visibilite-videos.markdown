---
layout: post
title:  "Facebook : Utiliser les Open Graph pour rendre vos vidéos visibles"
date:   2013-01-16 20:58:00 +0200
categories: video diffusion internet référencement
---
Auparavant, si vous désiriez partager sur Facebook une vidéo qui se trouvait sur votre blog et était hébergée par YouTube, il était obligatoire de partager le lien YouTube et non le lien de votre blog. Malheureusement, de ce fait, l’utilisateur ne visitait pas votre site.

Si vous souhaitez que vos vidéos puissent être lues directement depuis Facebook, vous devez utiliser <a title="Descripteurs OpenGraph" href="http://ogp.me" target="_blank">descripteurs d'OpenGraph</a>. Ce sont des métadonnées que vous devrez insérer dans les balises Head de votre site et qui permettront de fournir, tant à Facebook qu’aux autres sites utilisant ce standard, des informations comme le titre de la page, l’URL de votre site, l’auteur de la vidéo ...

<strong>Attention</strong> : Cet article vous donne des exemples très précis pour WordPress. Pour les autres éditeurs de contenu, je vous conseille de chercher sur la toile s’il existe des plugins équivalents.

L’idée est donc de <strong>rediriger le trafic vers votre page en attirant l’utilisateur grâce à votre vidéo</strong>. Après tout, c’est bien dans ce but que vous partagez vos vidéos sur les réseaux sociaux !

Comment procéder ?

Il faut utiliser <a href="http://index.activpik.com">Le service d'indexation vidéo Activpik Index</a> qui fournit les descripteurs à ajouter en en-tête de votre page. Une autre méthode serait de rédiger vos propres métadonnées à la main, mais cela s’avèrerait relativement fastidieux...

Si vous utilisez WordPress, il faut se servir d’un plugin pour personnaliser les en-têtes de vos pages, en fonction par exemple d’un article de blog ou d’une autre page. <a href="https://github.com/ludovic-bouguerra/wppostcustomheader">Ce plugin vous permettra de personnaliser vos en-têtes pour chacun de vos articles</a>. Il vous suffira de le télécharger et de le copier dans le dossier « wp-content/plugin » de WordPress. Après l’avoir activé lors de l’édition de vos articles, vous pourrez ajouter des informations dans l’en-tête de votre page.

<img alt="" src="http://www.ludovicbouguerra.fr/wp-content/uploads/2013/01/Capture-d’écran-2013-01-16-à-21.43.53.png" />

En voici quelques exemples :

<pre class="brush: html; gutter: true; first-line: 1; highlight: []; html-script: false">
&lt;meta property=&quot;og:video&quot; content=&quot;http://example.com/movie.swf&quot; /&gt;
&lt;meta property=&quot;og:video:secure_url&quot; content=&quot;https://secure.example.com/movie.swf&quot; /&gt;
&lt;meta property=&quot;og:video:type&quot; content=&quot;application/x-shockwave-flash&quot; /&gt;
&lt;meta property=&quot;og:video:width&quot; content=&quot;400&quot; /&gt;
&lt;meta property=&quot;og:video:height&quot; content=&quot;300&quot; /&gt;
&lt;meta property=&quot;og:image&quot; content=&quot;http://example.com/ogp.jpg&quot; /&gt;
&lt;meta property=&quot;og:image:type&quot; content=&quot;image/jpeg&quot; /&gt;
&lt;meta property=&quot;og:image:width&quot; content=&quot;400&quot; /&gt;
&lt;meta property=&quot;og:image:height&quot; content=&quot;300&quot; /&gt;
</pre>
Expliquons ceci plus en détail :
<table>
<tr><td>og:video</td><td>Lien vers le fichier vidéo ou un player vidéo Flash avec comme paramètre l’URL de la vidéo</td></tr>
<tr><td>og:video:secure_url</td><td>Lien sécurisé (HTTPS) vers le fichier vidéo ou un player vidéo Flash avec comme paramètre l’URL de la vidéo</td></tr>
<tr><td>og:video:type</td><td>Type de la vidéo ; attention Facebook n’accepte que le format Flash ou un fichier vidéo au format mp4</td></tr>
<tr><td>og:video:width</td><td>Largeur de la vidéo.</td></tr>
<tr><td>og:video:height</td><td>Hauteur de la vidéo.</td></tr>
<tr><td>og:image</td><td>URL pour l’image servant d’aperçu de la vidéo</td></tr>
<tr><td>og:image:type</td><td>Type de l'image</td></tr>
<tr><td>og:video:width</td><td>Largeur de l'image.</td></tr>
<tr><td>og:video:height</td><td>Hauteur de l'image.</td></tr>
</table>

Si vous souhaitez tester votre code, vous pouvez vous aider de Facebook Debugger. Vous pourrez ainsi savoir si Facebook détecte les vidéos présentes sur votre blog.

<strong>Petite astuce</strong> : Si votre vidéo est hébergée sur YouTube, vous pouvez directement copier ces balises en regardant le code-source de la page.

Prenons par exemple cette page :
http://www.activpik.com/embed/

 <img src="http://www.ludovicbouguerra.fr/wp-content/uploads/2013/01/Capture-d’écran-2013-01-16-à-22.20.40.png" />

En la partageant sur Facebook, vous pourrez lire la vidéo directement depuis Facebook ; et en cliquant sur le lien, vous parviendrez à l’article du blog, et non à la plateforme qui héberge votre vidéo. Le trafic Web est donc redirigé sur votre blog et non sur YouTube ou assimilés. Mission accomplie !

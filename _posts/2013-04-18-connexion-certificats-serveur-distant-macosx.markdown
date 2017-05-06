---
layout: post
title:  "Se connecter à l'aide de certificats sur un serveur distant depuis Mac OS X"
date:   2013-04-18 21:36:00 +0200
categories: macosX administration serveur
---
La connexion à l'aide de certificats sur un serveur distant permet de sécuriser votre serveur SSH. (A condition que vous ayez empêché la connexion par login / mot de passe).

Dans cet article nous allons créer une clé SSH sur notre client sous MAC OS X, envoyer notre clé publique sur le serveur distant. Et se connecter à titre d'essai.

<h1>Création d'une clé</h1>
Ouvrons un <strong>terminal</strong> et créons la clé :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
ssh-keygen -t rsa -b 2048
</pre>

Deux questions vont-vous être posés :
La première concerne le fichier ou sera stockée votre clé privée. Si vous n'en avez pas une de générée. Vous pouvez conserver ce nom de fichier.

<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/ludovic/.ssh/id_rsa):
</pre>

La seconde est un mot de passe pour protéger votre clé privée :
<pre>
Enter passphrase (empty for no passphrase):
</pre>

Pour des raisons de sécurité <strong>je vous conseille fortement</strong> de mettre un mot de passe. Si jamais quelqu'un récupère votre clé qui n'est pas protégé il pourra se connecter sur l'ensemble des serveurs, usurper votre identité ...

<h1>Copie de la clé sur le serveur distant</h1>

<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
cat ~/.ssh/id_rsa.pub | ssh utilisateur@ip-serveur &quot;umask 077; mkdir -p .ssh ; cat &gt;&gt; .ssh/authorized_keys&quot;
</pre>

Après avoir entré votre mot de passe, Vous pourrez vous connecter sur votre serveur sans mot de passe.

<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
ssh utilisateur@ip-serveur
</pre>

<strong>Note importante </strong> : Si vous avez changé le nom du fichier de votre clé, il faut l'indiquer lors de votre connexion.

<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
ssh utilisateur@ip-serveur -i cheminverslaclé/macle
</pre>

Si vous utilisez des clés différentes pour vous connecter à votre serveur, je vous suggère de vous renseigner sur le fichier ~/.ssh/config

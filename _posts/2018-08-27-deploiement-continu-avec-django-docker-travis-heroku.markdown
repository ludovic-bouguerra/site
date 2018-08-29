---
layout: post
title:  "Intégration Continue et Déploiement continu avec Django - Docker - Travis - Heroku. Partie 2 - Déploiement continu"
date:   2017-08-14 11:01:00 +0200
categories: django docker travis heroku
long_description: Nous allons mettre en place le déploiement continu sur Heroku. Nous utiliserons le container Registry pour déployer notre application. Cet article fait suite à la partie présentant l'intégration continue avec Travis.
thumbnail: /images/posts/integration-continue-deploiement-continu-django-docker-travis-p1/thumbnail.jpeg

---


A présent nous allons nous occuper du déploiement automatique grâce via Heroku. Cet article fait suite à la partie présentant l'intégration continue avec Travis si vous ne l'avez pas lu vous le trouverez ici :
[Intégration continue avec Docker, Travis Django](/django/docker/travis/heroku/2017/08/14/integration-continue-django-docker-travis.html){:target="_blank"}

Il faut dans un premier temps créer un compte sur le site d'Heroku, nous utiliserons l'offre gratuite.
)

Ensuite nous allons devoir télécharger le client en mode console ce lien vous explique comment procéder en fonction de votre configuration logicielle.

Le téléchargement se passe à cette adresse :  [Téléchargement client Heroku](https://devcenter.heroku.com/articles/heroku-cli#download-and-install){:target="_blank"}

L'interface ressemblera à l'image ci-dessous, il vous suffira de choisir la version correspondante à votre environement.


![Download heroku cli](/images/posts/deploiement-continu-django-docker-travis-p2/heroku-client-download.png)


```
heroku login
```

Entrez vos identifiants, si tout s'est bien passé vous êtes logués depuis votre et pourrez effectuer des opérations sur votre compte.

Nous allons installer le plugin heroku qui offre un "container-registry".

```
heroku plugins:install heroku-container-registry
```

Puis nous allons nous connecter sur le container registry


```
heroku container:login
```

Nous créons une application Heroku

```
heroku create
```

Et nous envoyons la première version de notre code sur le Docker registry d'Heroku


```
sudo heroku container:push web
```

A présent nous devons publier notre application.

```
sudo heroku container:release web
```

A présent nous avons réussi à faire un envoi manuel, il nous reste plus qu'à intégrer cette opération dans Travis.

Travis propose 'nativement' la publication sur Travis :
nous trouvons la documentation ici :https://docs.travis-ci.com/user/deployment/heroku/

Comme la documentation il nous suffit de faire la commande suivante :

```
travis setup heroku
```

En répondant aux questions qui seront posées vous aurez Travis et Heroku parfaitement intégré..  
```
Detected repository as ludovic-bouguerra/tutorial-travis-docker, is this correct? |yes|
Heroku application name: |tutorial-travis-docker|
Deploy only from ludovic-bouguerra/tutorial-travis-docker? |yes|
Encrypt API key? |yes|
```

Il faut à présent envoyer les modifications faites par travis au fichier .travis.yml

```
git add .travis.yml
git commit -m "Travis.yml for heroku"
git push origin master
```

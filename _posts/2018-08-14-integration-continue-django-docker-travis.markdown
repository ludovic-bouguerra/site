---
layout: post
title:  "Intégration Continue et Déploiement continu avec Django - Docker - Travis - Heroku. Partie 1 - Intégration Continue"
date:   2017-08-14 11:01:00 +0200
categories: django docker travis heroku
long_description: Travis CI est une plateforme permettant de faire de l'intégration continue. Deux versions du service sont disponibles une gratuite pour les projets OpenSource (travis-ci.org), une autre payante pour les projets privés (travis-ci.com). Nous allons au cours de ce tutoriel mettre en place un service en python qui répondra juste Hello World lorsque nous l'interrogerons au point d'entrée /hello.
thumbnail: /images/posts/integration-continue-deploiement-continu-django-docker-travis-p1/thumbnail.jpeg

---

Prérequis : pour suivre ce tutoriel vous devez avoir connaissance de :

l'écosystème Docker (docker-compose, docker)
* Python
* Django
* Avoir un compte sur Github (ou en créer un : https://github.com/)

Travis CI est une plateforme permettant de faire de l'intégration continue. Deux versions du service sont disponibles une gratuite pour les projets OpenSource (travis-ci.org), une autre payante pour les projets privés (travis-ci.com).

Nous allons au cours de ce tutoriel mettre en place un service en python qui répondra juste Hello World lorsque nous l'interrogerons au point d'entrée /hello. Nous utiliserons Travis pour tester le bon fonctionnement de notre application avec le lancement automatique de tests unitaires et si les tests sont bons nous déploierons l'application.

En résumé la pile logicielle et l'infrastructure complète que nous utiliserons est la suivante :

* Docker
* Django (Python 2.7)
* Docker Hub

Dans un premier temps nous allons donc créer notre application Django, nous utiliserons directement une image Docker Python 2.7 pour travailler.

Nous allons créer un fichier Dockerfile à la racine de notre nouveau dossier de projet qui aura le contenu suivant :

```
FROM python:2.7
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
RUN pip install -r requirements.txt
ADD . /code/
```

Nous allons aussi créer un fichier requirements.txt qui va décrire l'ensemble des dépendances de notre application Python.

```
Django>=1.8,<2.0
```

Enfin créons un fichier docker-compose.yml qui permet d'enregistrer l'ensemble des services dont nous avons besoins.

version: '2'

{% highlight yml %}
services:
  app:
    build: .
    image: ludovic-bouguerra/travis-example
    command: python manage.py runserver 0.0.0.0:8000
    volumes:
      - .:/code
    ports:
      - "8000:8000"
{% endhighlight %}

A ce stade notre développement nous avons qu'un service "application" qui sera plus tard rejoint probablement par une base de donnée mais aussi par un serveur frontal.

Pour résumer à ce stade nous avons trois fichiers dans le dossier projet :

```

project-test/
... Dockerfile
... requirements.txt
... docker-compose.yml
```

A présent nous avons les prérequis pour pouvoir lancer la création de notre projet Django.

Lançons la création de notre projet :

```
docker-compose run app django-admin.py startproject example .
```

Cette commande nous permet de créer le projet django "example".

Dès à présent nous voyons que notre dossier project-test contient un dossier example et un dossier manage.py, ce sont des fichiers générés par django qui nous permettent de commencer à créer notre ou nos applications.

Il est temps de versionner notre code. Créons un projet sur Github que nous appellerons par exemple : tutorial-travis-docker. (Ce sera notre serveur git distant "origin")

![Création projet github](/images/posts/integration-continue-deploiement-continu-django-docker-travis-p1/creation-projet-github.jpeg)

![Création projet github](/images/posts/integration-continue-deploiement-continu-django-docker-travis-p1/creation-projet-github-2.jpeg)

A présent sur notre projet local créons un repository local

```
git init
```

Ajoutons notre serveur "distant" hébergé sur Github.

```
git remote add origin https://github.com/ludovic-bouguerra/tutorial-travis-docker
```

(Pensez à remplacer le nom d'utilisateur git et le nom du projet si vous ne l'avez pas nommé de la même manière).

Enfin effectuons notre premier pull (Git nous à créé quelques fichiers Readme, Licence ...)

```
git pull origin master
```

Notre premier commit (en ajoutant au préalable les fichiers que nous souhaitons envoyer) suivi du premier envoi sur le serveur distant.

```
git add Dockerfile docker-compose.yml example manage.py requirements.txt

git commit -m "project skeleton"

git push origin master
```

Nous allons maintenant nous concentrer sur les tests unitaires. Django vient avec une commande nous permettant de lancer les tests unitaires sur l'ensemble de l'application. Il suffit pour cela d’exécuter la commande suivante :

```
docker-compose run app ./manage.py test
```

Et comme par miracle ;) cette commande nous retourne :

```
Creating test database for alias 'default'...
System check identified no issues (0 silenced).

----------------------------------------------------------------------
Ran 0 tests in 0.000s

OK
Destroying test database for alias 'default'...
```

Il faut avouer que nous avons pas encore fait grand chose ( 0 tests effectués ), toutefois nous allons pouvoir dès à présent integrer Travis dans notre Workflow.

Rendez-vous sur le site https://travis-ci.org/ dès que vous êtes connectés sur la plateforme nous avons accès à notre tableau de bord.

![Accueil Travis CI](/images/posts/integration-continue-deploiement-continu-django-docker-travis-p1/accueil-travis-ci.jpeg)


Sur la gauche se trouve vos projets sous Github enregistrés sur Travis, lorsque le fond est vert tout s'est bien passés, les tests unitaires passent, lorsque le fond est rouge il y'a eu un problème.

Nous allons dans notre tutoriel programmer Travis pour faire en sorte qu'il puisse dès les tests unitaires passent publier notre image sur DockerHub et enfin déployer l'application sur notre serveur.

Nous allons devoir enregistrer notre nouveau projet Git sur Travis. Cliquez sur le + (encadré en rouge) puis sélectionnez le projet que vous venez de créer sur Github. Si il n'est pas visible cliquez sur "Sync account"

![Ajouter projet Travis CI](/images/posts/integration-continue-deploiement-continu-django-docker-travis-p1/accueil-travis-ci-add.jpeg)


![Activer Projet Travis CI](/images/posts/integration-continue-deploiement-continu-django-docker-travis-p1/activer-projet-travis-ci.jpeg)

Pour fonctionner Travis à besoin d'un fichier qui doit être placé à la racine du projet qui se nomme .travis.yml.

```
sudo: required
language: python
services:
  - docker
script:
  -  docker-compose run app ./manage.py test
```

Ce fichier indique à Travis qu'il s'agit d'un projet Python, que nous allons avoir besoin de docker.

Ajoutons ce fichier dans notre système de gestion version, et publions nos modifications sur notre serveur central.

```
git add .travis.yml
git commit -m "Travis integration"
git push origin master
```

Rendons nous à présent sur le tableau de bord de Travis, au bout de quelques minutes vous devriez voir un indicateur vert nous indiquant que le processus de test s'est bien passé. Grâce à Travis-ci vous allez pouvoir exécuter certaines commande lorsque les tests se sont bien passés comme par exemple : mettre à jour votre application sur votre serveur, créer un release sur Github, ...

![Résultat tests Travis CI](/images/posts/integration-continue-deploiement-continu-django-docker-travis-p1/dashboard-travis-ci.jpeg)

Nous allons à présent ajouter notre première fonctionnalité qui est :

Créer un point d'entrée /hello sur notre site
Afficher "Hello World" lorsque le client fait une requête.
Nous créerons dans un premier temps le tests puis ensuite nous ferons le développement de la fonction.
Cette partie ne sera pas commentée car la connaissance de Django est un prérequis.

```
docker-compose run app ./manage.py startapp webservice
```

Nous créons une application que nous appellerons webservice

Dans le fichier webservice/tests.py écrivons notre premier test :

```
# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.test import TestCase, Client

class HelloTest(TestCase):

    def test_hello_world(self):
        c = Client()
        response = c.get('/hello')
        self.assertEquals("hello world", response.content)

```

Testons le lancement du test qui devrait évidemment échouer ;).

Django nous réponds effectivement :

```
======================================================================
FAIL: test_hello_world (webservice.tests.HelloTest)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/code/webservice/tests.py", line 11, in test_hello_world
    self.assertEquals("hello world", response.content)
AssertionError: u'hello world' != '<h1>Not Found</h1><p>The requested URL /hello was
not found on this server.</p>'

----------------------------------------------------------------------
Ran 1 test in 0.010s

FAILED (failures=1)
Destroying test database for alias 'default'...
```

Publions volontairement ce test qui est en échec sur Github et étudions la réaction sur Travis.

```
git add webservice
git commit -m "Publish fail test"
﻿git push origin master
```

Comme prévu sur notre tableau de bord Travis le test est marqué en échec.

![Résultat tests Travis CI](/images/posts/integration-continue-deploiement-continu-django-docker-travis-p1/dashboard-travis-ci-echec.jpeg)

Ajoutons à présent la fonctionnalité :

Dans le fichier example/urls.py

Remplacez le contenu par celui-ci :

```
"""example URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.11/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url
from django.contrib import admin
from webservice.views import hello_world_view

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^hello$', hello_world_view, name='hello_world')
```
et dans fichier webservice/views remplacez également le contenu :

```
# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render
from django.http import HttpResponse


def hello_world_view(request):
    return HttpResponse("hello world", content_type="text/plain")

```

Lançons les tests pour valider le fonctionnement :

```
docker-compose run app ./manage.py test
```

On constate effectivement que les tests se passent bien :

```
Creating test database for alias 'default'...
System check identified no issues (0 silenced).
.
----------------------------------------------------------------------
Ran 1 test in 0.006s

OK
```

Nous pouvons aussi lancer l'application et observer le bon fonctionnement depuis notre navigateur :

```
docker-compose up
```

Rendez-vous à l'url suivante :

```
http://localhost:8000/hello
```

On constate bien que l'application retourne hello world.

Nous pouvons donc publier notre code et voir la réaction du côté de Travis.

```
git add example/urls.py webservice/views.py
git commit -m "Adding /hello endpoint"
git push origin master
```

![Résultat tests Travis CI](/images/posts/integration-continue-deploiement-continu-django-docker-travis-p1/dashboard-travis-ci-succes.jpeg)

Avant de passer au déploiement automatique nous allons devoir configurer le mode WSGI de Django qui nous permettra de déployer l'application facilement ensuite.

Pour cela nous ajoutons dans le fichier requirements.txt le serveur uwsgi, ce qui nous donne un fichier requirements.txt qui à la forme suivante

```
Django>=1.8,<2.0
uwsgi
```

Nous allons aussi ajouter un entrypoint à notre application Django qui lancera le serveur WSGI si aucun argument n'est fourni.

Nous allons donc créer un fichier entrypoint.sh avec le contenu suivant

```
#!/bin/bash
#	Entrypoint
#
#
COMMAND=${@:1}

if [ -z $1 ]; then
	COMMAND="uwsgi"
fi

if [ "$COMMAND" = "uwsgi" ]; then
	COMMAND="/usr/local/bin/uwsgi -s https://www.linkedin.com/redir/invalid-link-page?url=0%2e0%2e0%2e0%3A8000 --module=example.wsgi:application"
fi

eval $COMMAND
```

Enfin nous allons modifier notre Dockerfile pour prendre en compte l'EntryPoint

```
FROM python:2.7
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
RUN pip install -r requirements.txt
ADD . /code/

ENTRYPOINT ["./entrypoint.sh"]

RUN chmod +x /code/entrypoint.sh

CMD ["./entrypoint.sh", "uwsgi"]
```

Nous constatons qu'avec peu d'investissement en temps nous pouvons facilement intégrer Travis dans nos projets et donc avoir une démarche automatisée de vérification de l'application. Il est d'ailleurs possible de rajouter d'autres informations comme la couverture en tests du code mais aussi de vérifier si le code respecte bien la charte de l'entreprise (CamelCase ...). Lors du prochain article nous mettrons en place le déploiement automatique sur Heroku.

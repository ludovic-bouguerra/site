---
layout: post
title:  "Installer votre Site Django sur un serveur mutualisé 1and1"
date:   2014-10-15 11:01:00 +0200
categories: django 1and1
long_description: Aujourd’hui les offres d’hébergement mutualisées ne sont plus uniquement compatibles avec PHP. Il est possible d’héberger des sites en Python, Ruby, Perl. Toutefois cela n’est pas sans limitations mais nous allons voir qu’il est assez simple d’installer un site développé en Python avec Django sous 1and1.
redirect_from: "/2014/10/installer-site-django-serveur-mutualise-1and1/l"


---
Aujourd'hui les offres d'hébergement mutualisées ne sont plus uniquement compatibles avec PHP. Il est possible d'héberger des sites en Python, Ruby, Perl. Toutefois cela n'est pas sans limitations mais nous allons voir qu'il est assez simple d'installer un site développé en Python avec Django sous 1and1.

Ce tutoriel est inspiré de cet article en anglais : http://robhogg.me.uk/post/2

Nous allons dans un premier temps configurer l'environnement en installant Django et Flup.

Depuis votre shell serveur téléchargez la version de Django correspondante :

Vous trouverez les différentes version à cette page : https://www.djangoproject.com/download/

Prenons par exemple la version 1.6.5

{% highlight bash %}
wget https://www.djangoproject.com/download/1.6.7/tarball/
tar xzf Django*tar.gz
cd Django*/
python setup.py install --user # Django will be installed to .local in your home folder
cd ..
{% endhighlight %}

A présent nous allons télécharger flup :
Vous trouverez les différentes versions ici : https://pypi.python.org/pypi/flup
Téléchargez le fichier avec l'extension egg qui correspond à votre version de python.
Dans notre cas :
{% highlight bash %}wget https://pypi.python.org/packages/2.6/f/flup/flup-1.0.2-py2.5.egg#md5=93ec6e3baeee3e5649a8456105178d4e
unzip flup*
mv flup ~/.local/lib/python*/site-packages/
{% endhighlight %}
A présent testons le bon fonctionnement :
{% highlight bash %}python -c "import django"
{% endhighlight %}
Cette ligne ne devrait pas retourner d'erreur.

Configuration de l'environnement web.
Création d'un dossier pour l'application
{% highlight bash %}mkdir web
{% endhighlight %}
Création d'un dossier public pour le serveur web.

{% highlight bash %}
mkdir app
{% endhighlight %}

Création d'un fichier .htaccess
{% highlight bash %}
AddHandler fcgid-script .fcgi
RewriteEngine on
RewriteBase /


# Exclude any paths that should be served literally:
RewriteRule     ^static/                -                       [L,NC]
# Add a default page
#RewriteRule    ^$                      home                    [NC]

RewriteCond %{REQUEST_FILENAME} !(cgi-bin/main.fcgi)
RewriteRule     ^(.*)$                  cgi-bin/main.fcgi/$1    [QSA,L]


{% endhighlight %}

Création d'un fichier main.fcgi qui aura pour but de lancer l'application. Ce fichier devra être mis dans un nouveau dossier cgi-bin qui lui sera dans le dossier web.
{% highlight bash %}
cd web
mkdir cgi-bin
nano main.fcgi
{% endhighlight %}

Le contenu du fichier se trouve ci-dessous.

{% highlight python %}
#!/usr/bin/python
import sys, os

basepath = "/../htdocs";

sys.path.insert(0, basepath + "/.local/lib")
sys.path.insert(0, basepath + "/.../app")

os.environ[DJANGO_SETTINGS_MODULE] = mon_projet.settings_production

from django.core.servers.fastcgi import runfastcgi
runfastcgi(method=threaded, daemonize=false)
{% endhighlight %}

Changement des droits pour ce fichier :

{% highlight bash %}
chmod 511 main.fcgi
{% endhighlight %}

Créez un dossier static dans le dossier web. Faites pointer le dossier staticfiles dans votre configuration de Django et faite appel à la commande collectstatic
{% highlight bash %}
python manage.py collectstatic
{% endhighlight %}


Vos fichiers statiques doivent être à présent accessibles.

Enfin pensez à faire pointer le domaine (ou sous-domaine) souhaité vers le dossier web.

---
layout: post
title:  "Android - Créer une application native"
date:   2018-09-20 19:30:00 +0200
categories: android ndk
long_description: Cet article présente comment créer sa propre application native Android.
thumbnail: /images/posts/creer-application-native-android/thumbnail.png

---

Pour réaliser ce tutoriel nous allons avoir besoin du Native Developement Kit d'Android disponible a cette adresse : https://developer.android.com/ndk/downloads/. Il vous suffira de télécharger la version qui correspond à votre système d'exploitation.

Nous allons réaliser un petit programme en C qui affichera le classique "Hello World". Effectivement rien de bien compliqué en terme de code. Le but étant plutôt de se familiariser avec la procédure de compilation et de structure de projet Android.

Avant toute chose il faut ajouter le NDK que vous venez de télécharger dans le path. Pour ma part il se trouve dans le dossier suivant :
```
/media/ludovic/lb/programs/android-ndk-r10e/
```

Pour ma part comme pour la la pluspart des distributions Linux il faut effectuer l'opération suivante pour l'ajouter au PATH :

```
export PATH="/media/ludovic/lb/programs/android-ndk-r10e/:$PATH"
```

Nous pouvons à présent tester la présence du programme :

```
ndk-build
```

Qui doit vous répondre quelque chose comme ça :

```
Android NDK: Could not find application project directory !    
Android NDK: Please define the NDK_PROJECT_PATH variable to point to it.    
/media/ludovic/lb/programs/android-ndk-r10e/build/core/build-local.mk:143: *** Android NDK: Aborting    .  Stop.
```

On peut donc commencer !

Commençons par l'architecture du projet :

Créons un dossier androidproject dans lequel on créera un dossier jni.

```
.. jni
... main.c
... Application.mk
... Android.mk

```

Dans le dossier jni nous mettrons notre fichier main.c

{% highlight c %}
#include <stdio.h>

int main(int argc, char* argv[]){
  printf("HELLO WORLD\n");
  return 0;
}
{% endhighlight %}


Il affichera le magnifique Hello World !

Enfin nous allons définir notre Android.mk :

{% highlight makefile %}
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := hello-world
LOCAL_SRC_FILES := main.c
LOCAL_CFLAGS += -fPIE
LOCAL_LDFLAGS += -fPIE -pie


include $(BUILD_EXECUTABLE)

{% endhighlight %}

Pour avoir plus d'informations sur le fichier Android.mk les informations se trouvent ici : https://developer.android.com/ndk/guides/android_mk


Enfin créeons notre fichier Application.mk

{% highlight makefile %}
APP_ABI := all
{% endhighlight %}


Il permet de cibler les architectures ici nous avons mis all mais il possible de cibler par exemple :

{% highlight makefile %}
APP_ABI := armeabi-v7a
{% endhighlight %}

Pour compiler uniquement la cible arm7 plus d'informations ici :
https://developer.android.com/ndk/guides/application_mk

Enfin dans le dossier de votre projet lancez la commande ndk-build. Vos programmes sont disponibles dans les dossiers :
libs/{ARCHITECTURES}/

```
libs/mips/hello-world
libs/mips64/hello-world

libs/armeabi-v7a/hello-world
libs/armeabi/hello-world
libs/arm64-v8a/hello-world

libs/x86/hello-world
libs/x86_64/hello-world
```

Il ne vous reste plus qu'a transférer l'exécutable sur votre téléphone pour le tester. Pour cela connectez votre téléphone en usb sur votre ordinateur, Activez le mode développeur.

```
adb push libs/armeabi-v7a/hello-world /data/local/tmp
adb shell chmod 755 /data/local/tmp/hello-world
adb shell /data/local/tmp/hello-world
```
Cette commande va transférer le programme, attribuer les droits d'exécution et le lancer. Et nous voyons notre fameux "Hello World".

Pensez à séléctionner l'architecture en fonction de votre device, pour moi c'était armeabi-v7a.

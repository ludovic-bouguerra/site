---
layout: post
title:  "Créer un VPN avec OpenVPN dans un conteneur OpenVZ"
date:   2012-11-23 22:45:00 +0200
categories: openvz proxmox openvpn
---
Si vous n'avez pas assez d'adresses IP publiques, que vous ne souhaitez pas rendre accessibles l'ensemble de vos machines depuis l'extérieur ...

Plusieurs raisons peuvent vous pousser à créer un réseau local composé de machines virtuelles. Cependant si vous voulez accéder à vos machines depuis internet soit vous vous connectez depuis votre interface Proxmox et vous accèdez à la console. Soit vous créez un réseau privé virtuel (VPN).

Nous allons dans un premier temps activer la fonction TUN/TAP du noyau linux sur le conteneur ou l'on souhaite installer OpenVPN.

conteneur est <strong>l'identifiant de la machine</strong> où l'on installera OpenVPN

Pour les deux commandes suivantes le <strong>conteneur doit être éteint</strong> ! Après avoir éteint le conteneur <strong>executez les commandes depuis l'hyperviseur</strong> (Votre serveur Proxmox).
{% highlight shell %}
vzctl set <em>conteneur</em> --devices c:10:200:rw --save
vzctl set <em>conteneur</em> --capability net_admin:on --save
{% endhighlight %}


Vous pouvez à présent rallumer votre conteneur.

Toujours depuis votre serveur Proxmox exécutez les commandes suivantes :
{% highlight shell %}
vzctl exec <em>conteneur</em> mkdir -p /dev/net vzctl exec <em>conteneur</em>
mknod /dev/net/tun c 10 200
vzctl exec <em>conteneur</em> chmod 600 /dev/net/tun
{% endhighlight %}

Il faut maintenant activer le module NAT d'iptable pour les conteneurs car par défaut celui-ci n'est pas activé. Sans activer ce module vous ne pourriez pas voir les machines virtuelles de votre réseau.

Faites une copie du fichier /etc/vz/vz.conf

{% highlight shell %}
cp /etc/vz/vz.conf /etc/vz/vz.conf.original
{% endhighlight %}

Modifiez la variable IPTABLES de /etc/vz/vz.conf de votre hyperviseur en mettant ceci :
{% highlight shell %}
IPTABLES="iptable_filter iptable_mangle ipt_limit ipt_multiport
ipt_tos ipt_TOS ipt_REJECT ipt_TCPMSS ipt_tcpmss ipt_ttl ipt_LOG
ipt_length ip_conntrack ip_conntrack_ftp ip_conntrack_irc ipt_conntrack
ipt_state ipt_helper iptable_nat ip_nat_ftp ip_nat_irc ipt_REDIRECT
ipt_LOG"
{% endhighlight %}


Redémarrez à nouveau votre conteneur.

Ensuite depuis votre conteneur il faut exécuter la commande suivante :

{% highlight shell %}
iptables -A POSTROUTING -o venet0 -j SNAT --to-source adresseIpDeVotreConteneur
{% endhighlight %}
A présent installons OpenVPN.

Depuis votre conteneur exécutez la commande suivante :
{% highlight shell %}
# apt-get instal openvpn</pre>
{% endhighlight %}

Il faut à présenter copier les fichiers de configuration et le scripts qui vont nous permettre de générer les certificats pour le serveur et les clients.
{% highlight shell %}
mkdir /etc/openvpn/easy-rsa/
cp -r /usr/share/doc/openvpn/examples/easy-rsa/2.0/* /etc/openvpn/easy-rsa/
chown -R openvpn /etc/openvpn/easy-rsa/
{% endhighlight %}

Editons le fichier de configuration par défaut afin de donner les bons paramètres aux certificats que nous allons générer.

Dans le fichier /etc/openvpn/easy-rsa/vars modifions les lignes suivantes :
{% highlight shell %}
export KEY_COUNTRY="Pays"
export KEY_PROVINCE="Etat"
export KEY_CITY="MA Ville"
export KEY_ORG="Nom de mon Orgranisation"
export KEY_EMAIL="email@email.com"
{% endhighlight %}

Générons les certificats pour le serveur :
{% highlight shell %}
cd /etc/openvpn/easy-rsa/
source vars
./clean-all
./build-dh
./pkitool --initca
./pkitool --server server
openvpn --genkey --secret keys/ta.key
{% endhighlight %}

Copions les fichiers générés et utile à OpenVPN.
{% highlight shell %}
# cp keys/ca.crt keys/ta.key keys/server.crt keys/server.key keys/dh1024.pem /etc/openvpn/
{% endhighlight %}

Créons le fichier de configuration du serveur :
{% highlight shell %}
# Serveur TCP/443
mode server
proto tcp
port 443
dev tun
# Cles et certificats
ca ca.crt
cert server.crt
key server.key
dh dh1024.pem
tls-auth ta.key 0
cipher AES-256-CBC
# Reseau
server 10.8.0.0 255.255.255.0
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 4.4.4.4"
push "dhcp-option DNS 8.8.8.8"
keepalive 10 120
# Securite
user nobody
group nogroup
chroot /etc/openvpn/jail
persist-key
persist-tun
comp-lzo
# Log
verb 3
mute 20
status openvpn-status.log
log-append /var/log/openvpn.log
{% endhighlight %}

Nous pouvons à présent lancer OpenVpn
{% highlight shell %}
# /etc/init.d/openvpn start
{% endhighlight %}

Vérifions dans le fichier Log que l'on trouve bien la mention "Initialization Sequence Completed" ce qui signifie que tout s'est bien passé !
{% highlight shell %}
cat /var/log/openvpn.log
{% endhighlight %}

Nous allons dans un sous dossier le fichier de configuration de base que devront avoir les clients :

{% highlight shell %}
mkdir /etc/openvpn/defaut/
{% endhighlight %}

{% highlight shell %}
# Configuraiton client
client
dev tun
proto tcp-client
remote adresseIPServeurVPN 443
resolv-retry infinite
cipher AES-256-CBC
# Cles
ca ca.crt
cert certificatClient.crt
key cleclient.key
tls-auth ta.key 1
# Securite
nobind
persist-key
persist-tun
comp-lzo
verb 3
{% endhighlight %}

Puis pour nos clients :

{% highlight shell %}
cd /etc/openvpn/easy-rsa
# source vars
# ./build-key macle
{% endhighlight %}



Nous allons afin de bien nous organiser stocker les clés et les configuration dans un dossier :
{% highlight shell %}
mkdir /etc/openvpn/clientconf/macle/
sudo cp /etc/openvpn/ca.crt /etc/openvpn/ta.key keys/macle.crt keys/macle.key /etc/openvpn/defaut/client.conf /etc/openvpn/clientconf/maclé/
{% endhighlight %}

Modifions le fichier client.conf pour y mettre les bonnes valeurs des clés clients :
nano /etc/openvpn/clientconf/macle/client.conf
{% highlight shell %}
cert macle.crt
key macle.key
{% endhighlight %}

Enfin pour rester compatible avec l'ensemble des clients OpenVpn faisons une copie de client.conf en client.ovpn

{% highlight shell %}
cp  /etc/openvpn/clientconf/macle/client.conf /etc/openvpn/clientconf/macle/client.ovpn
{% endhighlight %}

Vous pouvez à présent envoyer ce dossier ou le mettre au format zip pour que les utilisateurs puissent accèder au VPN.

{% highlight shell %}
# cd /etc/openvpn/clientconf/macle/
# zip macle.zip *.*
{% endhighlight %}

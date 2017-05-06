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
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
vzctl set &lt;em&gt;conteneur&lt;/em&gt; --devices c:10:200:rw --save
vzctl set &lt;em&gt;conteneur&lt;/em&gt; --capability net_admin:on --save
</pre>
&nbsp;

Vous pouvez à présent rallumer votre conteneur.

Toujours depuis votre serveur Proxmox exécutez les commandes suivantes :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
vzctl exec &lt;em&gt;conteneur&lt;/em&gt; mkdir -p /dev/net vzctl exec &lt;em&gt;conteneur&lt;/em&gt;
mknod /dev/net/tun c 10 200
vzctl exec &lt;em&gt;conteneur&lt;/em&gt; chmod 600 /dev/net/tun
</pre>

Il faut maintenant activer le module NAT d'iptable pour les conteneurs car par défaut celui-ci n'est pas activé. Sans activer ce module vous ne pourriez pas voir les machines virtuelles de votre réseau.

Faites une copie du fichier /etc/vz/vz.conf

<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
cp /etc/vz/vz.conf /etc/vz/vz.conf.original</pre>

Modifiez la variable IPTABLES de /etc/vz/vz.conf de votre hyperviseur en mettant ceci :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
IPTABLES=&quot;iptable_filter iptable_mangle ipt_limit ipt_multiport
ipt_tos ipt_TOS ipt_REJECT ipt_TCPMSS ipt_tcpmss ipt_ttl ipt_LOG
ipt_length ip_conntrack ip_conntrack_ftp ip_conntrack_irc ipt_conntrack
ipt_state ipt_helper iptable_nat ip_nat_ftp ip_nat_irc ipt_REDIRECT
ipt_LOG&quot;</pre>

Redémarrez à nouveau votre conteneur.

Ensuite depuis votre conteneur il faut exécuter la commande suivante :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
iptables -A POSTROUTING -o venet0 -j SNAT --to-source adresseIpDeVotreConteneur
</pre>
A présent installons OpenVPN.

Depuis votre conteneur exécutez la commande suivante :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
# apt-get instal openvpn</pre>

Il faut à présenter copier les fichiers de configuration et le scripts qui vont nous permettre de générer les certificats pour le serveur et les clients.
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
mkdir /etc/openvpn/easy-rsa/
cp -r /usr/share/doc/openvpn/examples/easy-rsa/2.0/* /etc/openvpn/easy-rsa/
chown -R openvpn /etc/openvpn/easy-rsa/
</pre>

Editons le fichier de configuration par défaut afin de donner les bons paramètres aux certificats que nous allons générer.

Dans le fichier /etc/openvpn/easy-rsa/vars modifions les lignes suivantes :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
export KEY_COUNTRY=&quot;Pays&quot;
export KEY_PROVINCE=&quot;Etat&quot;
export KEY_CITY=&quot;MA Ville&quot;
export KEY_ORG=&quot;Nom de mon Orgranisation&quot;
export KEY_EMAIL=&quot;email@email.com&quot;
</pre>

Générons les certificats pour le serveur :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
cd /etc/openvpn/easy-rsa/
source vars
./clean-all
./build-dh
./pkitool --initca
./pkitool --server server
openvpn --genkey --secret keys/ta.key
</pre>

Copions les fichiers générés et utile à OpenVPN.
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
# cp keys/ca.crt keys/ta.key keys/server.crt keys/server.key keys/dh1024.pem /etc/openvpn/
</pre>

Créons le fichier de configuration du serveur :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
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
push &quot;redirect-gateway def1 bypass-dhcp&quot;
push &quot;dhcp-option DNS 4.4.4.4&quot;
push &quot;dhcp-option DNS 8.8.8.8&quot;
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
</pre>

Nous pouvons à présent lancer OpenVpn
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
# /etc/init.d/openvpn start
</pre>

Vérifions dans le fichier Log que l'on trouve bien la mention "Initialization Sequence Completed" ce qui signifie que tout s'est bien passé !
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
cat /var/log/openvpn.log
</pre>

Nous allons dans un sous dossier le fichier de configuration de base que devront avoir les clients :

<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
mkdir /etc/openvpn/defaut/
</pre>

<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
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
</pre>

Puis pour nos clients :

<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
cd /etc/openvpn/easy-rsa
# source vars
# ./build-key macle
</pre>



Nous allons afin de bien nous organiser stocker les clés et les configuration dans un dossier :
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
mkdir /etc/openvpn/clientconf/macle/
sudo cp /etc/openvpn/ca.crt /etc/openvpn/ta.key keys/macle.crt keys/macle.key /etc/openvpn/defaut/client.conf /etc/openvpn/clientconf/maclé/
</pre>

Modifions le fichier client.conf pour y mettre les bonnes valeurs des clés clients :
nano /etc/openvpn/clientconf/macle/client.conf
<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
cert macle.crt
key macle.key
</pre>

Enfin pour rester compatible avec l'ensemble des clients OpenVpn faisons une copie de client.conf en client.ovpn

<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
cp  /etc/openvpn/clientconf/macle/client.conf /etc/openvpn/clientconf/macle/client.ovpn
</pre>

Vous pouvez à présent envoyer ce dossier ou le mettre au format zip pour que les utilisateurs puissent accèder au VPN.

<pre class="brush: shell; gutter: true; first-line: 1; highlight: []; html-script: false">
# cd /etc/openvpn/clientconf/macle/
# zip macle.zip *.*
</pre>

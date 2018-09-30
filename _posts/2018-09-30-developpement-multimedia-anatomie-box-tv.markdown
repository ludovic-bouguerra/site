---
layout: post
title:  "Développement multimédia - Anatomie d'une box TV"
date:   2018-09-30 19:30:00 +0200
categories: box tv multimédia freebox
long_description: Cet article présente l'architecture matérielle d'une box télévision, nous verrons également les utilitaires qui sont utilisés pour générer une distribution.
thumbnail: /images/posts/developpement-multimedia-comprendre-l-edid/thumbnail.png

---


## Architecture matérielle


![](/images/posts/developpement-multimedia-anatomie-box-tv/board.png)


<table>
  <tr>
    <td>
      Voltage Regulators
    </td>
    <td>Régulateurs de tensions
    </td>
  </tr>
  <tr>
    <td>
      Rôle
    </td>
    <td>
      Adapter les tensions selon la documentation de chaque composant.
    </td>    
  </tr>
</table>

<table>
  <tr>
    <td>SOC</td>
    <td>System on chip</td>
  </tr>
  <tr>
    <td>
      Fonctionnalités
    </td>
    <td>
    </td>    
  </tr>
  <tr>
    <td>
      Multimédia :
    </td>
    <td>
      Encodage H264 / Décodage H264
    </td>   
  </tr>  
  <tr>
    <td>
      Radio
    </td>
    <td>
      WIFI / BT
    </td>   
  </tr>  
  <tr>
    <td>
      Acteurs
    </td>
    <td>
      Broadcom / Realtek / Intel / ST
    </td>   
  </tr>  
</table>

<table>
  <tr>
    <td>
      Tunner TV
    </td>
    <td>
    </td>
  </tr>
  <tr>
    <td>
      Rôle
    </td>
    <td>
    Recevoir des flux provenant du cable / du satellite.
    </td>    
  </tr>
</table>


<table>
  <tr>
    <td>
      HDMI Transmitter
    </td>
    <td>
    </td>
  </tr>
  <tr>
    <td>
      Rôle
    </td>
    <td>
      Transmettre le flux vidéo à un écran
    </td>    
  </tr>
</table>

<table>
  <tr>
    <td>
      Ethernet PHY
    </td>
    <td>
    </td>
  </tr>
  <tr>
    <td>
      Rôle
    </td>
    <td>
      Assurer les communications réseaux
    </td>    
  </tr>
</table>

## Architecture logicielle

La majeure partie du temps il s'agit d'une distribution Linux. Plus récemment les systèmes intègrent Android TV.

---
layout: post
title:  "Le noyau Linux en pratique : Les partitions."
date:   2018-09-12 11:01:00 +0200
categories: linux kernel partitions disque embarqué
long_description: Cet article présente le fonctionnement des tables de partitions. Il permet très simplement de séparer un disque physiques en sous petits disques dur logiques.
thumbnail: /images/posts/noyau-linux-en-pratique-les-partitions/thumbnail.png

---

Pour ce tutoriel nous aurons besoin d'utiliser une distribution Linux avec Fdisk d'installé.

Pour comprendre la façon dont Linux utilise les partitions nous allons étudier un type de partition en particulier, les partitions msdos, puis nous généraliserons en étudiant la façon dont Linux les gère.

Il existe deux types principaux de systèmes de partitionnements sur les PC. Il s'agit deux formalismes qui permettent de décrire un "découpage" d'un disque en sous disques virtuels.

## Ne pas confondre système de partitionnement et système de fichiers

Un système de partitionnement décrit segmente un disque physique en sous disques virtuels. Cela ne décrit pas comment vont être stockés les fichiers, les dossiers. Cela s'appelle un système de fichiers. Je ferai prochainement un article. Bien qu'on indique dans une table de partition le type de système de fichier qui sera utilisé, cela ne doit pas être pris pour valeur sure car vous pouvez formater une partition annoncée en FAT par un système de fichier ext4 .

## Structure de la table des partitions ms-dos

Le partitionnement du disque est inscrit dans le MBR. Le MBR désigne les 512 premiers octets du disque dur, il va stocker le premier programme qui sera chargé par votre ordinateur mais aussi la table des partitions. La table des partitions au sein de la MBR se trouve à l'adresse 01BE de votre disque dur et fait 64 octets. Il est possible d'enregistrer 4 partition primaires, il s'agit donc d'un tableau de 4 entrées de 16 octets.

![](/images/posts/noyau-linux-en-pratique-les-partitions/partition-structure.png)

Source : Wikipedia.

Que contient ce tableau de 64 octets ?

```
typedef struct partition_entry {

    unsigned char boot;
    unsigned char start_cyl;
    unsigned char part_type;
    unsigned char end_cyl;
    unsigned int start_sec;
    unsigned int size;

} partition_entry;



partition_entry[4] partitons;
```

## Mise en pratique : Création d'un disque virtuel, création d'une table de partition.

Nous allons étudier ces deux systèmes pour cela nous utiliserons fdisk et gdisk sous linux

Dans un premier temps nous allons créer un disque virtuel de 10 Mo avec dd.

```
dd if=/dev/zero of=disk.img count=10 bs=1M
```

Cette commande permet de créer un fichier "disk.img" qui fera 10mo (10 x 1M - count x block size).

Consultons a cet instant la valeur de notre Master Boot Record

```
hexdump -v -n 512 disk.img
```

On constate qu'il a que des valeurs 0.

Nous allons maintenant utiliser FDISK pour créer un nouvelle table des partitions au format msdos.

```
fdisk disk.img
```

Nous allons créer 1 partition de 1 MO pour celà nous allons appuyer sur la touche n, p, 1 puis w.

```
Commande (m pour l'aide) : n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Numéro de partition (1-4, 1 par défaut) :
Premier secteur (2048-20479, 2048 par défaut) :
Last sector, +sectors or +size{K,M,G,T,P} (2048-20479, 20479 par défaut) : +1M

Created a new partition 1 of type 'Linux' and of size 1 MiB.
```

Nous allons sauvegarder en appuyant sur "w".

Enfin nous allons lire le contenu de notre MBR pour étudier les modifications effectuées par fdisk

```
0000000 0000 0000 0000 0000 0000 0000 0000 0000
0000010 0000 0000 0000 0000 0000 0000 0000 0000
0000020 0000 0000 0000 0000 0000 0000 0000 0000
0000030 0000 0000 0000 0000 0000 0000 0000 0000
0000040 0000 0000 0000 0000 0000 0000 0000 0000
0000050 0000 0000 0000 0000 0000 0000 0000 0000
0000060 0000 0000 0000 0000 0000 0000 0000 0000
0000070 0000 0000 0000 0000 0000 0000 0000 0000
0000080 0000 0000 0000 0000 0000 0000 0000 0000
0000090 0000 0000 0000 0000 0000 0000 0000 0000
00000a0 0000 0000 0000 0000 0000 0000 0000 0000
00000b0 0000 0000 0000 0000 0000 0000 0000 0000
00000c0 0000 0000 0000 0000 0000 0000 0000 0000
00000d0 0000 0000 0000 0000 0000 0000 0000 0000
00000e0 0000 0000 0000 0000 0000 0000 0000 0000
00000f0 0000 0000 0000 0000 0000 0000 0000 0000
0000100 0000 0000 0000 0000 0000 0000 0000 0000
0000110 0000 0000 0000 0000 0000 0000 0000 0000
0000120 0000 0000 0000 0000 0000 0000 0000 0000
0000130 0000 0000 0000 0000 0000 0000 0000 0000
0000140 0000 0000 0000 0000 0000 0000 0000 0000
0000150 0000 0000 0000 0000 0000 0000 0000 0000
0000160 0000 0000 0000 0000 0000 0000 0000 0000
0000170 0000 0000 0000 0000 0000 0000 0000 0000
0000180 0000 0000 0000 0000 0000 0000 0000 0000
0000190 0000 0000 0000 0000 0000 0000 0000 0000
00001a0 0000 0000 0000 0000 0000 0000 0000 0000
00001b0 0000 0000 0000 0000 3ad3 cebf 0000 2000
00001c0 0021 4183 0001 0800 0000 0800 0000 0000
00001d0 0000 0000 0000 0000 0000 0000 0000 0000
00001e0 0000 0000 0000 0000 0000 0000 0000 0000
00001f0 0000 0000 0000 0000 0000 0000 0000 aa55
0000200
```

On va retrouver les caractéristiques annoncées dans tableau extrait de Wikipedia, la signature du MBR aa55 à la fin. Nous allons maintenant examiner les 16 octets qui correspondent à notre première partition.

```
0000 2000 0021 4183 0001 0800 0000 0800
```

## Comment le noyau Linux gère les systèmes de partitions ?

### Les structures de données

Le code source concernant la gestion des partitions se trouve dans le dossier block/partitions. Il est disponible sur Github à l'adresse suivante : https://github.com/torvalds/linux/tree/master/block/partitions.

La structure représentant les partitions d'un périphérique se trouve dans le fichier block/partitions/check.h

Voici la structure de données :

```
struct parsed_partitions {
	struct block_device *bdev;
	char name[BDEVNAME_SIZE];
	struct {
		sector_t from;
		sector_t size;
		int flags;
		bool has_info;
		struct partition_meta_info info;
	} *parts;
	int next;
	int limit;
	bool access_beyond_eod;
	char *pp_buf;
};
```

### Comment le système détecte les partitions ?

Le fichier block/partitions/check.c est le point d'entrée principal, il va "enregistrer" l'ensemble des fonctions qui sont "capables de détecter des partitions", puis tester chaque système afin d'avoir la liste complète des partitions. Elle doivent respecter le formalisme suivant :

```
int detecteur_partition(struct parsed_partitions *state)
```

Elles doivent ensuite être listées dans le tableau suivant :

```
static int (*check_part[])(struct parsed_partitions *) = {
	/*
	 * Probe partition formats with tables at disk address 0
	 * that also have an ADFS boot block at 0xdc0.
	 */
#ifdef CONFIG_ACORN_PARTITION_ICS
	adfspart_check_ICS,
#endif
#ifdef CONFIG_ACORN_PARTITION_POWERTEC
	adfspart_check_POWERTEC,
#endif
#ifdef CONFIG_ACORN_PARTITION_EESOX
	adfspart_check_EESOX,
#endif

	/*
	 * Now move on to formats that only have partition info at
	 * disk address 0xdc0.  Since these may also have stale
	 * PC/BIOS partition tables, they need to come before
	 * the msdos entry.
	 */
#ifdef CONFIG_ACORN_PARTITION_CUMANA
	adfspart_check_CUMANA,
#endif
#ifdef CONFIG_ACORN_PARTITION_ADFS
	adfspart_check_ADFS,
#endif

#ifdef CONFIG_CMDLINE_PARTITION
	cmdline_partition,
#endif
#ifdef CONFIG_EFI_PARTITION
	efi_partition,		/* this must come before msdos */
#endif
#ifdef CONFIG_SGI_PARTITION
	sgi_partition,
#endif
#ifdef CONFIG_LDM_PARTITION
	ldm_partition,		/* this must come before msdos */
#endif
#ifdef CONFIG_MSDOS_PARTITION
	msdos_partition,
#endif
#ifdef CONFIG_OSF_PARTITION
	osf_partition,
#endif
#ifdef CONFIG_SUN_PARTITION
	sun_partition,
#endif
#ifdef CONFIG_AMIGA_PARTITION
	amiga_partition,
#endif
#ifdef CONFIG_ATARI_PARTITION
	atari_partition,
#endif
#ifdef CONFIG_MAC_PARTITION
	mac_partition,
#endif
#ifdef CONFIG_ULTRIX_PARTITION
	ultrix_partition,
#endif
#ifdef CONFIG_IBM_PARTITION
	ibm_partition,
#endif
#ifdef CONFIG_KARMA_PARTITION
	karma_partition,
#endif
#ifdef CONFIG_SYSV68_PARTITION
	sysv68_partition,
#endif
	NULL
};
```

Celui concernant les partitions msdos se trouve ici par exemple : https://github.com/torvalds/linux/blob/ead751507de86d90fa250431e9990a8b881f713c/block/partitions/msdos.c à la ligne 450.

Enfin la fonction check_partition va parcourir le tableau précédent tant qu'il n'a pas de partition détectée.

```
struct parsed_partitions *
check_partition(struct gendisk *hd, struct block_device *bdev)
```

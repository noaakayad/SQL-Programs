-- TP : 4
-- Date : 14/12/2023
-- Auteur : Antoine DUMONT, Noa AKAYAD

/* 1 Exécutez l’ordre : */

DROP TABLE ARBRE;

-- Que fait cet ordre ?
-- cet ordre supprimme la table 'arbre' si elle existe.*

/* 2 Téléchargez le fichier .csv depuis
https://opendata.paris.fr/explore/dataset/les-arbres/export/
avec toutes les données à disposition.  */

/* 3 A l’aide de l’outil d’importation de SQLDevelopper,  importez le fichier .csv. . Les données
seront importées dans la table ARBRE. */

/* 4  Mettez la clé primaire sur l’attribut IDBASE */

alter table ARBRE add constraint arbre_primaire primary key (IDBASE);

-- il semble que des valeurs sont nulles ou dupliquées : cherchons-les.

select count(*) from ARBRE where IDBASE is NULL;

-- le résultat est 0 : il n'y a pas d'ID nul

select IDBASE from ARBRE
GROUP BY IDBASE
HAVING   COUNT(*) > 1;

SELECT * FROM ARBRE where IDBASE = 227160;

-- le résultat est unique : la ligne d'IDBASE = 227160
-- On la supprime (j'ai remarqué que le stade de développement était différent entre les deux doublons :

DELETE FROM ARBRE
WHERE IDBASE = 227160 AND STADE_DE_DEVELOPPEMENT IS NULL;

/* 5. Les coordonnées géographiques sont dans un seul attribut de type VARCHAR2
comme une chaîne de caractère. L’avez-vous repéré ? */

--  oui 

/* 6. Examinez chaque colonne et décidez si elle est intéressante ou pas (colonne qui
contient une valeur de type clé qui n’est pas la clé, colonne qui a une même valeur
partout, colonne avec la valeur NULL, etc.) */

-- je commence par regarder si il y a des colonnes qui ont la même valeur partout : 
-- on recherche les candidates :

Select * from arbre;

-- 1 NUMERO semble être une colonne remplie de null
-- 2 type_emplacement semble être une colonne remplie de la même chose : 'arbre'
-- 3 REMARQUABLE semble être une colonne remplie de 'NON' ou de null

-- vérifions 1 :

Select count(*) from arbre where NUMERO is not null;

-- le resultat est 0 : il n'y a pas de ligne qui contient autre chose que NULL : supprimons la colonne.

ALTER TABLE arbre
DROP COLUMN NUMERO;

-- vérifions 2 : 

Select count(*) from arbre where TYPE_EMPLACEMENT <> 'Arbre' ;

-- le résultat est 0 : il n'y a pas de ligne qui contient autre chose que Arbre : supprimons la colonne.

ALTER TABLE arbre
DROP COLUMN TYPE_EMPLACEMENT;

-- vérifions 3 : 

Select count(*) from arbre where  REMARQUABLE <> 'NON' or REMARQUABLE IS NOT NULL ;

-- le résultat est 0 : il n'y a pas de ligne qui contient autre chose que NON ou null : supprimons la colonne.

ALTER TABLE arbre
DROP COLUMN REMARQUABLE;


/* PARTIE 2 */
/* 1. Faites connaissance avec cette table. */

select * from arrondissement;

/* 2. mettez une clé étrangère sur votre table ARBRE attribut ARRONDISSEMENT
qui référence ARRONDISSEMENT(NOM_ARR). */

alter table arbre add constraint arbre_etrangere foreign key (ARRONDISSEMENT)
references ARRONDISSEMENT(NOM_ARR);

/* PARTIE 3 */
/* 1 . Créez une table DENOMINATION_ARBRE telle que décrite dans le modèle EAR.
Les champs LIBELLE, GENRE et ESPECE ne doivent pas être NULL. Mettez la
valeur NULL comme valeur par défaut aux autres attributs de la table. Les champs
(LIBELLE, ESPECE, GENRE) forment (logiquement) la clé primaire. */

create table denomination_arbre (
libelle varchar2(255),
genre varchar2(255), 
espece varchar2(255),
age_limite int,
besoin_elagage varchar2(255),
feuilles_tombantes varchar2(255),
primary key (libelle, espece));

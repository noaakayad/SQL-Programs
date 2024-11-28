-- TP : 3
-- Date : 08/12/2023
-- Auteur : Antoine DUMONT, Noa AKAYAD

set AUTOCOMMIT on;

/*1. Créez votre propre table écrivain comme une copie de la table sys.ecrivain que
vous avez utilisée */

create table ecrivain as 
select * from sys.ecrivain;


/* 2. Vérifiez si votre table a des clés primaires ou étrangères. */

select all_cons_columns.constraint_name, all_cons_columns.column_name,  all_constraints.constraint_type
from all_cons_columns join all_constraints 
on all_cons_columns.constraint_name = all_constraints.constraint_name
where all_constraints.table_name = 'ECRIVAIN';

/* 3 Rajouter les contraintes référentielles nécessaires : mettez une clé primaire sur
l’attribut IDECR et une clé étrangère sur CHEF_DE_FILE qui pointe sur la même table. */

alter table ECRIVAIN add constraint ecrivain_primaire primary key (IDECR);

alter table ecrivain add constraint ecrivain_etrangere foreign key (CHEF_DE_FILE)
references ecrivain(IDECR);

/* 4 Modifier encore la table écrivain en lui supprimant la colonne genre_id. */

alter table ECRIVAIN drop column genre_id ;

/* 5 Affichez le contenu de votre table (avec une requête select *) et les contraintes
qui sont posées (avec l’outil graphique) */

select * from ECRIVAIN;

/* 6 Effacez un écrivain qui vous déplaît ou que vous ne connaissez pas en indiquant
son nom dans la partie WHERE. S’il y a une erreur qui apparaît expliquer pourquoi ; corrigez cette erreur. */

delete from ECRIVAIN 
where pnom = 'Ken' ; 

/* 7 Insérez dans la table ECRIVAIN un nouvel écrivain (que vous aimez bien) */

insert into ECRIVAIN (IDECR,enom,pnom,sexe,date_n,pays_n,chef_de_file,livres_vendus,valeur)
VALUES (7999,'Rowling','J.K','F',to_date('08/12/2023','dd/mm/yyyy'),'Angleterre',NULL,3,NULL);

/* 8  Modélisez le fait qu’un écrivain écrit des livres et qu’un livre est peuplé des personnages. 
Un livre a un seul auteur. Le modèle sous forme d’image (photo ou autre
document numérique) est à déposer sur ecampus */

-- cf word TP3

/* 9  Créez de toute pièce une nouvelle table OEUVRE censée garder les informations
sur une oeuvre d’écrivain. */

DROP TABLE personnages CASCADE CONSTRAINTS ;

create table oeuvre (
id_oeuvre int primary key,
titre varchar2(255), 
date_p date,
id_ecrivain int, 
foreign key (id_ecrivain) references ecrivain(IDECR));

/* 10 Créez aussi une table PERSONNAGE. Pour les deux tables prenez soin de mettre
des clés primaire et des clés étrangères */

create table personnages (
id_personnage int primary key,
nom varchar2(255), 
prenom varchar2(255),
descrip varchar2(255),
id_livre int, 
foreign key (id_livre) references oeuvre(id_oeuvre));


/* 11 Insérez des enregistrements dans les tables OEUVRE et PERSONNAGE. */

insert into Oeuvre (id_oeuvre,titre,date_p,id_ecrivain)
VALUES (5,'la bible de la SI',to_date('08/12/2023','dd/mm/yyyy'),7839);

insert into personnages (id_personnage,Nom,Prenom,descrip,id_livre)
VALUES (6666,'Noa','Akayad','Jeune bg à l école des mines',5);

insert into oeuvre (id_oeuvre,titre,date_p,id_ecrivain)
values (1, 'la histoire de YEAH YEAH', TO_DATE('08/12/2023', 'DD/MM/YYYY'), 7999);

insert into personnages (id_personnage,Nom,Prenom,descrip,id_livre)
values (9999, 'YEAH', 'YEAH', 'YEAAAAAAAAH', 1);


/* 12 Tentez d'insérer des enregistrements avec une clé étrangère qui n’existe pas dans
la table référencée. Interprétez ce qui se passe. */

insert into personnages (id_personnage,Nom,Prenom,descrip,id_livre)
values (9899, 'Anna', 'Abdul Massih', 'je t en veux', 9);

-- Rapport d'erreur -
-- ORA-02291: violation de contrainte d'intégrité (C##DUMONT.SYS_C0075989) - clé parent introuvable
-- interprétation : la clef étrangètre n'existe pas : ça marche pas

/* 13 Tentez d’effacer une oeuvre pour laquelle vous avez saisi des personnages */

Delete from oeuvre where titre = 'la bible de la SI';

-- Rapport d'erreur -
-- ORA-02292: violation de contrainte (C##DUMONT.SYS_C0075989) d'intégrité - enregistrement fils existant
-- interprétation : on ne peut pas supprimer si il y a des personnages


/* 14 Affichez pour chaque écrivain le nombre de personnages saisis dans la table PERSONNAGE, 0 pour ceux qui n’ont pas. */

Select pnom, count(p.nom) from ecrivain  
FULL OUTER join oeuvre on id_ecrivain = IDECR
FULL OUTER join personnages p on id_livre = id_oeuvre
group by pnom;


/* 15  Affichez le nombre d’enregistrements de la table ECRIVAIN qui n’ont rien de
saisi pour l’attribut VALEUR */

Select count(*) from ecrivain 
where valeur is NULL;

/* 16  Passez un mode AUTOCOMMIT OFF. , après une mise à jour correcte faites COMMIT ; */

SET AUTOCOMMIT OFF;

COMMIT ;

/* 17 Pour les enregistrements comptés dans la requête précédente, mettez 0 à la place
de la valeur NULL. */

UPDATE ecrivain
SET valeur = 0
WHERE valeur is NULL;

/* 18 Faites une mise à jour de l’attribut LIVRES_VENDUS en l’augmentant partout
de 25%. */

UPDATE ecrivain
SET Livres_vendus = Livres_vendus + 0.25 * Livres_vendus;

/*19 Faites une mise à jour de l’attribut VALEUR en l’augmentant du nombre de personnages présents dans la base. */

UPDATE ecrivain
SET VALEUR = VALEUR + (Select count(p.nom) from personnages p 
FULL OUTER join oeuvre on id_oeuvre = id_livre
where IDECR = id_ecrivain);

select pnom, valeur from ecrivain;





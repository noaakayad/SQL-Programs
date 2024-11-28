-- TP : 1
-- Date : 23/11/2023
-- Auteurs : Antoine Dumont, Noa Akayad

/* 1. Affichez la structure, puis le contenu de chacune des tables : ECRIVAIN */

desc ECRIVAIN;
select *
from ECRIVAIN;


/* 2. Déterminez pour chacune des tables son nombre d'enregistrements (3 requêtes). */

select count(*) from ECRIVAIN;

select count(*) from LOCALISATION;

select count(*) from GENRE;


/* 3. Affichez le nombre d’écrivains nés en France */

select count(IDECR) from ECRIVAIN
where PAYS_N = 'France';

/* 4. Affichez le nombre d’écrivains né dans un pays de votre choix autre que la France. */

select count(IDECR) from ECRIVAIN
where PAYS_N = 'Maroc';

/* 5. Affichez explicitement les écrivains nés dans un pays que vous avez choisi. */

select ENOM, PNOM from ECRIVAIN
where PAYS_N = 'France';

/* 6.  Affichez la même liste qu’au point précédent en choisissant uniquement le prénom
et le nom qui apparaîtront sous la forme Marie DUPONT, à savoir le prénom, suivi
d’un espace, suivi du nom en majuscule ; cette colonne s’appellera Ecrivain */

select PNOM || ' ' || upper(ENOM) as ECRIVAIN from ECRIVAIN
where PAYS_N = 'France';

/* 7. Affichez tous les écrivains avec leur nom, prénom et leur date de naissance. Si les
dates affichées vous semblent bizarres faites la commande : ALTER SESSION SET nls_date_format=’dd / mm / yyyy’;
Ré-exécutez la requête antérieure. */

ALTER SESSION SET nls_date_format='day / month / year';

select ENOM, PNOM, DATE_N from ECRIVAIN;


/* 8. Affichez la même liste qu’au point précédent en la triant selon la date de naissance,
en ordre croissant, puis en ordre décroissant. */

select ENOM, PNOM, DATE_N from ECRIVAIN

ORDER BY DATE_N;

/* 9. Affichez les écrivains (prénom/nom) avec leur mois de naissance en toute lettre
et triez la dans l’ordre logique : Janvier, février, Mars ... (utilisez la fonction
TO_CHAR et un patron de conversion de la date). */

ALTER SESSION SET nls_date_format='month';

select ENOM, PNOM, DATE_N from ECRIVAIN

order by TO_CHAR(DATE_N,'mm');


/* 10. Affichez chaque écrivain (prénom/nom) et son nombre de livres vendus. */

select PNOM, ENOM, LIVRES_VENDUS from ECRIVAIN;

/* 11.  Affichez les nombres maximal et minimal des livre vendus. */

select MAX(LIVRES_VENDUS), MIN(LIVRES_VENDUS) from ECRIVAIN;

/* 12. (*)Affichez l’écrivain avec le plus de livres vendus. */

select PNOM, ENOM from ECRIVAIN
where LIVRES_VENDUS = (select MAX(LIVRES_VENDUS) from ECRIVAIN);

/* 13. Affichez les écrivains qui portent un prénom qui vous plaît, ou qui commence par
une syllabe qui vous plaît ’Mi’, par exemple. */

select PNOM, ENOM from ECRIVAIN
where PNOM = 'Alexandre'  OR PNOM LIKE 'Mi%';





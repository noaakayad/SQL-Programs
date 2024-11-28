# TP 5
# Auteurs : AKAYAD Noa, DUMONT Antoine
# Date : 27/12/23


# Partie 2 : 
import oracledb
import matplotlib.pyplot as plt

con = oracledb.connect('c##akayad/test@193.49.175.51:1521/cdb1')

denominations_test = ["Chêne", "Erable", "Tilleul"]


def analyse_elagage (arbre) :
    sql = f"""
            select idbase from sys.arbre
            where libelle = '{arbre}'
            and (domanialite = 'Alignement' or domanialite = 'Jardin')"""
    
    s = 0
    cursor = con.cursor()
    for result in cursor.execute(sql):
        s = s + 1
    cursor.close()
    return s > 30

def visualisation (arbre) :
    sql_ali = f"""
            select hauteur from sys.arbre
            where libelle = '{arbre}'
            and domanialite = 'Alignement'"""
    cursor1 = con.cursor()
    cursor1.execute(sql_ali)
    hauteurs_alignement = [ligne[0] for ligne in cursor1]
    cursor1.close()
    
    sql_jar = f"""
            select hauteur from sys.arbre
            where libelle = '{arbre}'
            and domanialite = 'Jardin'"""
    cursor2 = con.cursor()
    cursor2.execute(sql_jar)
    hauteurs_jardin = [ligne[0] for ligne in cursor2]
    cursor2.close()
    
    plt.hist([hauteurs_alignement, hauteurs_jardin], bins=10, color=['blue', 'red'], label=['Alignement', 'Jardin'])
    plt.title(f"Hauteurs des {arbre}s en Alignement et Jardin")
    plt.xlabel('Hauteur (m)')
    plt.ylabel('Nombre')
    plt.legend()
    plt.show()
    

def visu_test() :
    for arbre in denominations_test :
        if analyse_elagage (arbre) :
            visualisation (arbre)

visu_test()


# Partie 3 : 
def peut_elaguer(arbre):

    seuil_elagage = 3
    seuil_nombre_exemplaires = 30
    

    sql = f"""
        select avg(hauteur) from sys.arbre
        where libelle = '{arbre}'
        and arrondissement not like 'BOIS%'"""

    cursor1 = con.cursor()
    cursor1.execute(sql)
    hauteur_moyenne = cursor1.fetchone()[0]
    cursor1.close()


    sql_nombre_exemplaires = f"""
        select count(*) from sys.arbre
        where libelle = '{arbre}'
        and arrondissement not like 'BOIS%'"""
    
    cursor2 = con.cursor()
    cursor2.execute(sql_nombre_exemplaires)
    nombre_exemplaires = cursor2.fetchone()[0]
    cursor2.close()


    if hauteur_moyenne is not None and hauteur_moyenne > seuil_elagage :
        if nombre_exemplaires >= seuil_nombre_exemplaires:
            return f"L'arbre '{arbre}' peut être élagué. Cet élaguage doit être effectué à partir de {seuil_elagage} mètres."
    
    return f"L'arbre '{arbre}' ne nécessite pas d'élagage."



con.close()


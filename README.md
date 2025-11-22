# SAE_SHELL
Membres du groupe : Camille Kasteleyn, Theo Hecquet, Fabien Lembre

# LISTE DES PROBLEMES ENREGISTRER : 
    lister les livres : commence a la ligne 3 (n'affiche pas le petit prince)
    modif des livres : devrons-nous pas ignorer les cases? 
    !! Regler l'alerte des emprunts !! 
    afficher les genre qui existe ?

    incomprehension : dans recherche les read sont dans les fonctions mais dans gestion non  




### Partie de Camille :
**Partie recherche et filtres :**  
- *searchTitle()* : rechercher par titre (recherche partielle)
- *searchAuthor()* : rechercher par auteur
- *searchGender()* : filtrer par genre
- *searchYears()* : filtrer par année (plage de dates)

### Partie de Théo :


### Partie de Fabien :
**Partie Documentation, Livrables et Tests**

**Partie recherche et filtres :**
- *SearchAll()* Recherche avancée (un ou plusieurs critères combinés)

**Partie gestion des emprunts :**  
- *emprunter_livre()* : Ajoute un emprunt dans emprunts.csv et met le statut du livre à *emprunté* dans books.csv. 
- *retourner_livre()* : met le statut de l'emprunt à *rendu* dans emprunts.csv et le statut du livre à *disponible* dans books.csv
- *Livres_Empruntes()* : Retourne la liste des livres actuellement empruntés
- *Livres_en_retard()* : Retoune les livres dont la date de rendu est dépassé si le livre n'est pas encore rendu.
- *Historique_emprunts()* : Retourne la liste des emprunts d'un livre (avec son ID) ou tous les emprunts si on ne donne pas d'ID
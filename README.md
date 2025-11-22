# SAE_SHELL : Système de Gestion de Bibliothèque Personnelle

### Objectifs :
 * Manipulation de fichiers texte  
 * Gestion de données structurées sans base de données  
 * Menu interactif et interface utilisateur  
 * Fonctions de recherche et filtrage  
### Description :
 Créer un système complet de gestion de livres avec fichiers plats (CSV/texte).

### Membres du groupe (Groupe TP C) : 
 * Vincent Duriez (22300445)
 * Camille Kasteleyn  
 * Theo Hecquet (22204967)
 * Fabien Lembre (22303886)

## Répartition des tâches :

### Partie de Vincent :
**Partie gestion des livres :**  
- *add_book()* : ajouter un livre avec génération automatique d'ID
- *modify_book()* : modifier un livre existant
- *delbook()* : supprimer un livre 
- *print_books()* : lister tous les livres avec pagination

### Partie de Camille :
**Partie recherche et filtres :**  
- *searchTitle()* : rechercher par titre (recherche partielle)
- *searchAuthor()* : rechercher par auteur
- *searchGender()* : filtrer par genre
- *searchYears()* : filtrer par année (plage de dates)

### Partie de Théo :
**Partie statistiques et rapports :**  
- *total_books()* : Nombre total de livres
- *number_books_by_gender()* : Répartition par genre (graphique ASCII)
- *top_5_authors()* : Top 5 auteurs les plus présents
- *books_by_decades()* : Livres par décennie
- **PAS ENCORE FAIT** Export des résultats en HTML ou PDF

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
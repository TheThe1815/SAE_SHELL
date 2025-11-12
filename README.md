# SAE_SHELL : Système de Gestion de Bibliothèque Personnelle
### Objectifs :
 * Manipulation de fichiers texte  
 * Gestion de données structurées sans base de données  
 * Menu interactif et interface utilisateur  
 * Fonctions de recherche et filtrage  
### Description :
 Créer un système complet de gestion de livres avec fichiers plats (CSV/texte).

### Membres du groupe (Groupe TP C) : 
 * Vincent Duriez  
 * Camille Kasteleyn  
 * Theo Hecquet  
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
- **PAS ENCORE FAIT** Recherche avancée (plusieurs critères combinés)

### Partie de Théo :
**Partie statistiques et rapports :**  
- *total_books()* : Nombre total de livres
- *number_books_by_gender()* : Répartition par genre (graphique ASCII)
- *top_5_authors()* : Top 5 auteurs les plus présents
- *books_by_decades()* : Livres par décennie
- **PAS ENCORE FAIT** Export des résultats en HTML ou PDF

### Partie de Fabien :
**Partie Documentation, Livrables et Tests**


### Partie GPTo
Parfait — tu veux un plan détaillé pour réaliser ce projet sans que je te donne le code complet. Voici une feuille de route complète, étape-par-étape, avec structures, algorithmes, validations, organisation du travail et points de contrôle. Tu peux suivre ça pour implémenter bibliotheque.sh et lib_functions.sh toi-même.

1. Vue d'ensemble / architecture

Stockage : deux fichiers plats (ex. livres.txt, emprunts.txt) avec champs séparés par |.

Fichiers source : bibliotheque.sh (interface/menu), lib_functions.sh (fonctions réutilisables).

Format dates : utiliser ISO YYYY-MM-DD (facile à comparer).

Sauvegarde : dossier backups/ avec rotations journalières.

Contrainte : tout en bash (ou sh) — pas de base de données.

2. Schéma de fichiers (exacts)

livres.txt : ID|Titre|Auteur|Année|Genre|Statut

Exemple : 001|1984|George Orwell|1949|Dystopie|disponible

emprunts.txt : ID_Livre|Emprunteur|Date_Emprunt|Date_Retour_Prévue

Exemple : 001|Alice Dupont|2025-11-01|2025-11-15

3. Organisation du code (fichiers & fonctions)

bibliotheque.sh

charge lib_functions.sh

boucle principale du menu interactif

gère navigation, pagination, appels aux fonctions

lib_functions.sh

I/O fichier : lire_livres(), ecrire_livres(), lire_emprunts(), ecrire_emprunts()

CRUD livres : ajouter_livre(), modifier_livre(), supprimer_livre(), lister_livres(page, taille)

Recherche / filtres : chercher_par_titre(substr), chercher_par_auteur(auteur), filtrer_genre(genre), filtrer_annee(min,max), recherche_avance(criteria)

Statistiques : compter_total(), repartition_par_genre(), top_auteurs(n), livres_par_decennie()

Emprunts : emprunter_livre(id, emprunteur, date_retour), retourner_livre(id), lister_empruntes(), alerte_retards(), historique_emprunts(id?)

Utilitaires : generer_id(), valider_entree(), sauvegarde_automatique(), backup_quotidien(), verrou_fichier()

4. Principes d'accès aux fichiers (sécurité et atomicité)

Toujours lire le fichier complet en mémoire (ou en boucle) puis écrire dans un fichier temporaire, puis mv pour remplacer — évite corruption.

Utiliser verrouillage (ex. flock) si plusieurs instances possibles.

Après chaque modification, appeler sauvegarde_automatique() pour écrire et créer un backup incrémental si besoin.

5. Génération d’ID

Stratégies :

trouver le plus grand ID existant et faire +1 (format à 3 chiffres : printf "%03d").

ou combiner date+seq (ex. 20251112-001) si besoin.

Implémentation : lors de ajouter_livre(), lire tous les IDs, calculer le suivant, puis écrire la nouvelle ligne.

6. Validation des saisies

Titre/Auteur : non vide, longueur max raisonnable.

Année : nombre 4 chiffres entre 1000 et l’année courante.

Genre : optionnel ou pré-liste (ex. Dystopie, Science-Fiction, Roman, Histoire).

Dates : regex ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ et vérification existence (validation simple : vérifier mois 01–12 et jour 01–31 ; pour robustesse, utiliser date -d pour parser).

Statut : disponible / emprunté.

7. Pagination pour lister

Arguments : page (1-based) et taille (ex. 10 par page).

Calcul : start = (page-1) * taille, end = start + taille - 1.

Lire toutes les lignes, extraire tranche entre start et end, afficher avec numéros.

Dans le menu : offres n (next), p (prev), q (quit).

8. Recherches et filtres

Recherche partielle titre : chercher substring insensible à la casse (grep -i ou awk).

Recherche par auteur : correspondance exacte partielle.

Filtre par genre : égalité simple.

Filtre par année plage : convertir champs année en int et tester min <= année <= max.

Recherche avancée : combiner filtres successifs (appliquer filtre A → résultat → filtre B).

Implémenter logique AND par défaut ; proposer OR si souhaité.

9. Statistiques & rapports

Nombre total : compter lignes non vides.

Répartition par genre : compter occurrences de chaque genre, afficher histogramme ASCII :

pour chaque genre : nom | ##### (longueur proportionnelle au nombre).

Top 5 auteurs : compter auteurs, trier décroissant, prendre premiers 5.

Livres par décennie : decennie = (année/10)*10, compter.

Export HTML : générer un template HTML basique (tableaux, titres) et écrire fichier report.html.

Export PDF : deux approches

Générer HTML + utiliser wkhtmltopdf report.html report.pdf (ou pandoc) — documenter dépendance dans README.

Ou générer Markdown et convertir via pandoc.

Important : dans ton readme, indiquer comment produire les PDF localement (commande requise).

10. Emprunts (logique métier)

Emprunter :

Vérifier statut du livre (disponible).

Ajouter ligne dans emprunts.txt et changer statut du livre à emprunté.

Date d’emprunt = aujourd’hui (auto), Date retour prévue = date fournie.

Retourner :

Supprimer/archiver l’entrée d’emprunt (ou ajouter dans historique) et remettre statut à disponible.

Conserver historique : créer emprunts_historique.txt où chaque emprunt retourné est ajouté.

Alertes retards :

Parcourir emprunts.txt, comparer Date_Retour_Prévue avec date courante; lister les retards.

Option : envoyer notifications (dans un script local, afficher warnings).

Historique : possibilité de rechercher par ID livre ou par emprunteur.

11. Sauvegardes quotidiennes

Script backup_quotidien.sh (ou fonction) :

Copie des fichiers livres.txt et emprunts.txt dans backups/YYYY-MM-DD/.

Rotation : conserver N derniers jours (ex. 7), supprimer anciens.

Planification : documenter crontab à ajouter (ex. 0 2 * * * /chemin/backup_quotidien.sh), mais ne pas exiger cron dans l’exercice — proposer comme option.

12. Robustesse & tests

Jeux de données : fournir 50–200 livres de test couvrant divers genres/années/auteurs.

Tests à faire :

Ajout / suppression / modification → vérifier fichier et sauvegardes.

Emprunter livre déjà emprunté → doit échouer avec message.

Recherche avec accents / casse → vérifier comportement.

Pagination bordures (page vide, dernière page partielle).

Statistiques : vérifier valeurs avec jeux de données connus.

Cas limites : lignes vides, caractères | dans les titres (éviter ou échapper), doublons d’ID (éviter).

13. Interface utilisateur (menu)

Menu principal (exemples d’entrées) :

Gérer livres

Ajouter

Modifier

Supprimer

Lister (pagination)

Rechercher/Filtrer

Emprunts

Emprunter

Retourner

Lister emprunts

Alertes retards

Statistiques & Export

Sauvegarde / Restore

Quitter

Toujours demander confirmation avant suppression définitive.

Messages utilisateurs clairs, erreurs en rouge (si terminal supporte ANSI), succès en vert.

14. README et répartition du travail (livrables)

README doit contenir :

Noms + numéros des étudiants.

Répartition du travail (qui a fait quoi : UI, I/O fichiers, recherches, statistiques, tests).

Instructions d’installation (dépendances comme wkhtmltopdf, pandoc), exemples de commandes, comment lancer.

Comment exécuter jeux de données de test.

Répartition suggérée (pour 3–4 étudiants) :

Étudiant A : I/O fichiers, génération d’ID, sauvegarde/backup.

Étudiant B : CRUD livres + validation.

Étudiant C : Emprunts et historique.

Étudiant D : Statistiques / exports / README / jeux de données.

15. Timeline sur 2 semaines (exemple)

Jour 1–2 : conception, structure, définir formats.

Jour 3–6 : implémentation CRUD, I/O, ID, validation.

Jour 7–9 : emprunts et logique état.

Jour 10–11 : statistiques, export HTML.

Jour 12 : tests & jeux de données.

Jour 13 : README, nettoyages, backup automation.

Semaine 3 (présentation) : préparation slides + démo.

16. Sécurité & bonnes pratiques

Échapper/valider toute saisie qui ira dans un shell ou fichier.

Ne pas stocker données sensibles.

Utiliser set -euo pipefail (si bash) dans les scripts pour attraper erreurs (documenter mais ne pas imposer).

Utiliser fonctions petites et testables.

17. Fonctionnalités optionnelles « bonus »

Tagging multi-genre (séparé par ;).

Interface textuelle améliorée (ncurses / dialog).

Recherche fuzzy (approx) — plus complexe.

Import/Export CSV standard.

Interface web minimale (si autorisé).

18. Erreurs fréquentes à éviter

Écrire directement dans le fichier principal sans fichier temporaire → corruption.

Ne pas verrouiller → perte de données si plusieurs accès.

Ne pas gérer les accents/encoding → mauvaises recherches.

Supposer que tous les utilisateurs utilisent la même locale.
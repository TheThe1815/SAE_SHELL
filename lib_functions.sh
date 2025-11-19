#!/bin/bash

# ----------------------- Gestion des livres -----------------------

# Vérifie ou crée le fichier CSV
csv_existe() {
    if [ ! -e "books.csv" ]; then
        echo "ID,Titre,Auteur,Année,Genre,Statut" > "books.csv"
        return 1
    else
        return 0
    fi
}

# Ajoute un livre
add_book() {    
    local titre="$1"
    local auteur="$2"
    local annee="$3"
    local genre="$4"
    csv_existe
   
    local id=$(wc -l books.csv | cut -d' ' -f1 | tr -s " " )
    if ! [[ "$annee" =~ ^[0-9]{1,4}$ ]] || [ "$annee" -gt "$(date +%Y)" ]; then
        echo "Erreur : L'année n'est pas valide."
        return  1
    fi

    # Vérifie si le livre existe (match exact du titre dans la colonne Titre)
    if grep -q ",$titre," books.csv; then
        echo "Livre deja existant"
        return  1
    fi
    echo "$id,$titre,$auteur,$annee,$genre,disponible" >> "books.csv"
    echo "Livre '$titre' ajouté avec succès."
}

# Modifie un livre par son titre
modify_book() {
    local titre="$1"
    local ntitre="$2"
    local nauteur="$3"
    local nannee="$4"
    local ngenre="$5"
    local nstatut="$6"

    # Vérifie que le livre existe
    if ! grep -q ",$titre," books.csv; then
        echo "Erreur : Livre '$titre' non trouvé."
        return  1
    fi

    # Construit la nouvelle ligne
    local nouvelle_ligne="$(grep ",$titre," books.csv | cut -d, -f1),$ntitre,$nauteur,$nannee,$ngenre,$nstatut"

    # Remplace la ligne
    sed -i "/,$titre,/c\\$nouvelle_ligne" books.csv
    echo "Livre '$titre' modifié avec succès."
}

# Supprime un livre
delbook() {
    local titre="$1"

    # Vérifie que le livre existe
    if ! grep -q ",$titre," books.csv; then
        echo "Erreur : Livre '$titre' non trouvé."
        return  1
    fi

    # Supprime la ligne
    grep -v ",$titre," books.csv > books.tmp && mv books.tmp books.csv
    echo "Livre '$titre' supprimé avec succès."
}

# Affiche les livres avec pagination
print_books() {
    local page=1
    local per_page=5
    local total_lines=$(wc -l < "books.csv")
    local total_pages=$(( (total_lines - 1 + per_page - 1) / per_page ))  # -1 pour ignorer l'en-tête

    while true; do
        clear
        echo -e "=== Liste des livres (page $page/$total_pages) ===\n"

        # Affiche l'en-tête
        head -n 1 "books.csv" | sed 's/,/ | /g'
        echo "--------------------------------------------------------------------------------"

        # Calcule les lignes à afficher
        local start_line=$(( (page - 1) * per_page + 2 ))  # +2 pour sauter l'en-tête
        local end_line=$(( start_line + per_page - 1 ))

        # Affiche les lignes de la page courante
        tail -n +2 "books.csv" | sed -n "${start_line},${end_line}p" | while IFS=, read -r id titre auteur annee genre statut; do
            echo -e "$id | $titre | $auteur | $annee | $genre | $statut"
        done

        echo -e "\n"
        echo -e "n: page suivante | p: page précédente | q: quitter\n"
        read -n 1 -s -r key
        case $key in
            n)
                if [ $page -lt $total_pages ]; then
                    ((page++))
                fi
                ;;
            p)
                if [ $page -gt 1 ]; then
                    ((page--))
                fi
                ;;
            q)
                break
                ;;
        esac
    done
}

# ----------------------- Recherche et filtres -----------------------

# Affiche les informations d'un livre donné avec son ID
afficheLivre() {
    local id_r="$1"

    if [ -z "$id_r" ]; then
        echo "Erreur"
        return 1
    fi

    local lignes
    lignes=$(grep -E "^${id_r}," books.csv)

    [ -z "$lignes" ] &&  echo "Aucun livre avec l'ID $id_r" && return 1
    

    while IFS="," read -r id titre auteur annee genre statut; do
        echo "-----------Livre-------------"
        echo "--------ID : $id"
        echo "--------Titre : $titre"
        echo "--------Auteur : $auteur"
        echo "--------Année : $annee"
        echo "--------Genre : $genre"
        echo "--------Statut : $statut"
        echo "-----------------------------"
    done <<< "$lignes"
}

# Recherche de livre par titre
searchTitle() {
    read -p "Entrez un titre pour la recherche : " motcle

    #on enleve tous les espaces inutiles
    motcle=$(echo "$motcle" | tr -s ' ')

    #si le titre est vide
    [ -z "$motcle" ] && echo "Un titre ne peut pas etre vide nonuche" && return
    

    lignes=$(grep -i "$motcle" books.csv | tr -s ' ' | cut -d',' -f1,2)

    #si il n'y a aucun titre
    [ -z "$lignes" ] && echo "Aucun titre correspondant" && return

    #affichage des lignes qui contiennent le titre
    echo "$lignes" | while IFS=',' read -r id; do
        afficheLivre "$id"
    done
}

# Recherche de livre par auteur
searchAuthor(){
    read -p "Entrez un auteur pour la recherche : " motcle

    #on enleve tous les espaces inutiles
    motcle=$(echo "$motcle" | tr -s ' ')

    #si l'auteur est vide
    [ -z "$motcle" ] && echo "Un auteur ne peut pas etre vide nonuche" && return
    
    lignes=$(grep -i "$motcle" books.csv | tr -s ' ' | cut -d',' -f1,3)

    #si il n'y a aucun auteur
    [ -z "$lignes" ] && echo "Aucun auteur correspondant" && return

    #affichage des lignes qui contiennent l'auteur
    echo "$lignes" | while IFS=',' read -r id auteur; do
        afficheLivre "$id"
    done
}

# Recherche de livre par genre
searchGender(){
    read -p "Entrez un genre pour la recherche (...): " motcle

    #on enleve tous les espaces inutiles
    motcle=$(echo "$motcle" | tr -s ' ')

    #si le genre est vide
    [ -z "$motcle" ] && echo "Un genre peut pas etre vide nonuche" && return

    lignes=$(grep -i "$motcle" books.csv | tr -s ' ' | cut -d',' -f1,5)

    #si il n'y a aucun 
    [ -z "$lignes" ] && echo "Aucun genre correspondant" && return

    #affichage des lignes qui contiennent le genre
    echo "$lignes" | while IFS=',' read -r id genre; do
        afficheLivre "$id"
    done
}

# Recherche de livre par année
searchYears(){
    read -p "Entrez une année pour la recherche : " motcle

    #on enleve tous les espaces inutiles
    motcle=$(echo "$motcle" | tr -s ' ')

    #si l'année est vide
    [ -z "$motcle" ] && echo "Un annee peut pas etre vide nonuche" && return

    lignes=$(grep -i "$motcle" books.csv | tr -s ' ' | cut -d',' -f1,4)

    #si il n'y a aucun livre pour l'annee demander
    [ -z "$lignes" ] && echo "Aucune année correspondante" && return

    #affichage des lignes qui contiennent le genre
    echo "$lignes" | while IFS=',' read -r id annee; do
        afficheLivre "$id"
    done
}

searchAll(){
    read -p "Entrez des mots clé pour la recherche : " motscle
    lignes=`tail -n +2 books.csv`
    for mot in $motscle; do
        lignes=`echo "$lignes" | grep -i "$mot"`
    done

    [ -z "$lignes" ] && echo "Aucun livre correspondant" && return

    echo "$lignes" | while IFS=',' read -r id _; do
        afficheLivre "$id"
    done
}

# ----------------------- Statistiques et Rapports -----------------------

# Affiche le nombre total de livres et ceux empruntés
total_books() {
    local cpt_emprunts=$(wc -l < "emprunts.csv")
    local cpt_livres=$(wc -l < "books.csv")

    ((cpt_livres--))
    ((cpt_emprunts--))
    echo "Nombre total de livres dans la bibliothèque : $nb_livres dont $cpt_emprunts empruntés."
}

number_books_by_gender() {
    echo "--- Par Genre ---"
    # On utilise "books.csv" directement pour éviter l'erreur de variable vide
    if [ ! -f "books.csv" ]; then echo "Fichier introuvable"; return; fi

    tail -n +2 "books.csv" | cut -d',' -f5 | sort | uniq -c | while read count genre; do
        printf "%-15s [%s] : " "$genre" "$count"
        # Histogramme
        for ((i=0; i<count; i++)); do printf "#"; done
        echo ""
    done
}

top_5_authors() {
    echo "--- Top 5 Auteurs ---"
    if [ ! -f "books.csv" ]; then echo "Fichier introuvable"; return; fi

    tail -n +2 "books.csv" | cut -d',' -f3 | sort | uniq -c | sort -nr | head -n 5
}

books_by_decades() {
    echo "--- Par Décennies ---"
    if [ ! -f "books.csv" ]; then echo "Fichier introuvable"; return; fi

    # Fichier temporaire pour le calcul
    > decades.tmp
    tail -n +2 "books.csv" | cut -d',' -f4 | while read annee; do
        # Vérifie que l'année est bien un nombre avant de calculer
        if [[ "$annee" =~ ^[0-9]+$ ]]; then
            dec=$(( (annee / 10) * 10 ))
            echo "$dec" >> decades.tmp
        fi
    done
    
    sort decades.tmp | uniq -c
    rm decades.tmp
}

# ----------------------- Emprunts -----------------------

emprunter_livre() {
    read -p "Entrez l'ID du livre à emprunter : " id_livre
    grep -q "^$id_livre," books.csv
    if [ $? -ne 0 ]; then
        echo "Livre avec ID $id_livre non trouvé."
        return 1
    fi
    statut=`grep "^$id_livre," books.csv | cut -d',' -f6 | tr -d '\r'`
    echo "Statut du livre : $statut"
    if [ "$statut" = "emprunté" ]; then
        echo "Le livre avec ID $id_livre est déjà emprunté."
        return 1
    fi
    # Remplace "disponible" par "emprunté" pour ce livre dans books.csv
    sed -i "/^$id_livre,/s/disponible/emprunté/" books.csv
    read -p "Entrez le nom de l'emprunteur : " nom_emprunteur
    date_emprunt=$(date +%Y-%m-%d)
    read -p "Entrez la date de retour prévue (YYYY-MM-DD) : " date_retour 
    if [[ ! "$date_retour" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "Format de date de retour invalide."
        return 1
    fi
    # Vérifie que la date existe réellement
    if ! date -d "$date_retour" "+%Y-%m-%d" >/dev/null 2>&1; then
        echo "La date de retour n'existe pas."
        return 1
    fi
    if [[ "$date_retour" < "$date_emprunt" ]]; then
        echo "La date de retour doit être postérieure à la date d'emprunt."
        return 1
    fi
    echo "$id_livre,$nom_emprunteur,$date_emprunt,$date_retour" >> emprunts.csv
}

retourner_livre() {
    read -p "Entrez l'ID du livre à retourner : " id_livre
    grep -q "^$id_livre," books.csv
    if [ $? -ne 0 ]; then
        echo "Livre avec ID $id_livre non trouvé."
        return 1
    fi
    statut=`grep "^$id_livre," books.csv | cut -d',' -f6 | tr -d '\r'`
    if [ "$statut" = "disponible" ]; then
        echo "Le livre avec ID $id_livre n'est pas emprunté."
        return 1
    fi
    # Remplace "emprunté" par "disponible" pour ce livre dans books.csv
    sed -i "/^$id_livre,/s/emprunté/disponible/" books.csv
}

# ----------------------- Tests des fonctions -----------------------

add_book "bible" "appotre" "50" "SF" 
add_book "bible" "appotre" "50" "SF" 
add_book "Mon Livre" "Moi" "2020" "SF" #marche avec debug 

modify_book "Le Petit Prince" "Le Petit Prince" "Antoine de Saint-Exupéry" "1943" "Conte" "emprunté" #marche mais sensible aux espaces et a la casse donc pas ouf
#sleep 1
delbook "bible" #marche
print_books 

#searchTitle #marche mais recherche pas uniquement dans le titre (ex : pour 1984, le livre ayant le titre 1984 et le livre datant de 1984 seront affichés)
#searchAuthor #pareil
#searchGender #pareil
#searchYears #pareil et ça doit rechercher les livres entre 2 années
searchAll

total_books #Marche maintenant 
number_books_by_gender #Marche maintenant 
top_5_authors #Marche maintenant 
books_by_decades #Marche maintenant 
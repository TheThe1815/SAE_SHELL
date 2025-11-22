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
    if ! grep -qi ",$titre," books.csv; then
        echo "Erreur : Livre '$titre' non trouvé."
        return  1
    fi

    # Construit la nouvelle ligne
    local nouvelle_ligne="$(grep -i ",$titre," books.csv | cut -d, -f1),$ntitre,$nauteur,$nannee,$ngenre,$nstatut"

    # Remplace la ligne
    sed -i "/,$titre,/c\\$nouvelle_ligne" books.csv
    echo "Livre '$titre' modifié avec succès."
}

# Supprime un livre
delbook() {
    local titre="$1"

    # Vérifie que le livre existe
    if ! grep -qi ",$titre," books.csv; then
        echo "Erreur : Livre '$titre' non trouvé."
        return  1
    fi

    # Supprime la ligne
    grep -vi ",$titre," books.csv > books.tmp && mv books.tmp books.csv
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
        local start_line=$(( (page - 1) * per_page + 1 ))  # +2 pour sauter l'en-tête
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
    [ -z "$motcle" ] && echo "Un titre ne peut pas etre vide" && return

    #affichage des lignes qui contiennent le titre
    trouver=0
    while IFS=',' read -r id titre auteur annee genre statue; do
        if echo "$titre" | grep -iq "$motcle"; then
            afficheLivre "$id"
            trouver=1
        fi
    done < <(tail -n +2 books.csv)

    [ "$trouver" -eq 0 ] && echo "Aucun titre correspondant"
}

# Recherche de livre par auteur
searchAuthor(){
    read -p "Entrez un auteur pour la recherche : " motcle

    #on enleve tous les espaces inutiles
    motcle=$(echo "$motcle" | tr -s ' ')

    #si l'auteur est vide
    [ -z "$motcle" ] && echo "Un auteur ne peut pas etre vide" && return

    #affichage des lignes qui contiennent l'auteur
    trouver=0
    while IFS=',' read -r id titre auteur annee genre statue; do
        if echo "$auteur" | grep -iq "$motcle"; then
            afficheLivre "$id"
            trouver=1
        fi
    done < <(tail -n +2 books.csv)

    [ "$trouver" -eq 0 ] && echo "Aucun auteur correspondant"
}

# Recherche de livre par genre
searchGender(){
    read -p "Entrez un genre pour la recherche (...): " motcle

    #on enleve tous les espaces inutiles
    motcle=$(echo "$motcle" | tr -s ' ')

    #si le genre est vide
    [ -z "$motcle" ] && echo "Un genre peut pas etre vide" && return

    #affichage des lignes qui contiennent le genre
    trouver=0
    while IFS=',' read -r id titre auteur annee genre statue; do
        if echo "$genre" | grep -iq "$motcle"; then
            afficheLivre "$id"
            trouver=1
        fi
    done < <(tail -n +2 books.csv) #Option pour garder les modif dans un while

    [ "$trouver" -eq 0 ] && echo "Aucun genre correspondant"
}

# Recherche de livre par année
searchYears(){
    read -p "Entrez l'année de debut pour la recherche : " a1
    read -p "Entrez l'année de fin pour la recherche : " a2

    #on enleve tous les espaces inutiles
    a1=$(echo "$a1" | tr -s ' ')
    a2=$(echo "$a2" | tr -s ' ')

    #si l'année est vide
    [[ -z "$a" && -z "$a2" ]] && echo "Un annee peut pas etre vide" && return

    #si a1 est plus grand que a2, on les inverse
    if [ "$a1" -gt "$a2" ]; then
        tmp=$a1
        a1=$a2
        a2=$tmp
    fi

    #affichage des lignes ou l'année est compris entre les dates
    trouver=0
    while IFS=',' read -r id titre auteur annee genre statue; do
<<<<<<< HEAD
        if [[ "$annee" -ge "$a1" && "$annee" -le "$a2" ]]; then
=======
        if [ "$annee" -ge "$a1"] && ["$annee" -le "$a2"]; then
>>>>>>> 4dce532ab48e8a8435fc12b2f5212c7fce569074
            afficheLivre "$id"
            trouver=1
        fi
    done < <(tail -n +2 books.csv) #Option pour garder les modif dans un while

    [ "$trouver" -eq 0 ] && echo "Aucune annee correspondante"
}

searchAll(){
    # Recherche de livre par mots clé dans toutes les colonnes
    read -p "Entrez des mots clé pour la recherche (laisser vide pour tout afficher) : " motscle
<<<<<<< HEAD
    lignes=$(tail -n +2 books.csv)
=======
    lignes=`tail -n +2 books.csv`
>>>>>>> 4dce532ab48e8a8435fc12b2f5212c7fce569074
    # on enleve les livres qui ne contiennent pas tous les mots clés 
    for mot in $motscle; do
        lignes=$(echo "$lignes" | grep -i "$mot")
    done

    [ -z "$lignes" ] && echo "Aucun livre correspondant" && return

    #affichage des lignes qui contiennent les mots clés
    echo "$lignes" | while IFS=',' read -r id _; do
        afficheLivre "$id"
    done
}

# ----------------------- Statistiques et Rapports -----------------------

# Affiche le nombre total de livres et ceux empruntés
total_books() {
    local cpt_emprunts=$(grep -c ",emprunté" books.csv)
    local cpt_livres=$(wc -l < "books.csv")

    ((cpt_livres--))
    echo "Nombre total de livres dans la bibliothèque : $cpt_livres dont $cpt_emprunts empruntés."
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
    # demande l'ID du livre à emprunter
    read -p "Entrez l'ID du livre à emprunter : " id_livre
    # Vérifie que le livre existe
    grep -q "^$id_livre," books.csv
    if [ $? -ne 0 ]; then
        echo "Livre avec ID $id_livre non trouvé."
        return 1
    fi
    # Vérifie si le livre est déjà emprunté
    statut=`grep "^$id_livre," books.csv | cut -d',' -f6 | tr -d '\r'`
    echo "Statut du livre : $statut"
    if [ "$statut" = "emprunté" ]; then
        echo "Le livre avec ID $id_livre est déjà emprunté."
        return 1
    fi

    # demande le nom de l'emprunteur et la date de retour prévue
    read -p "Entrez le nom de l'emprunteur : " nom_emprunteur
    date_emprunt=$(date +%Y-%m-%d) #date du jour
    read -p "Entrez la date de retour prévue (YYYY-MM-DD) : " date_retour 

    # Vérifie le format de la date de retour
    if [[ ! "$date_retour" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "Format de date de retour invalide."
        return 1
    fi
    # Vérifie que la date existe réellement
    if ! date -d "$date_retour" "+%Y-%m-%d" >/dev/null 2>&1; then
        echo "La date de retour n'existe pas."
        return 1
    fi
    # Vérifie que la date de retour est postérieure à la date d'emprunt
    if [[ "$date_retour" < "$date_emprunt" ]]; then
        echo "La date de retour doit être postérieure à la date d'emprunt."
        return 1
    fi

    # Remplace "disponible" par "emprunté" pour ce livre dans books.csv
    sed -i "/^$id_livre,/s/disponible/emprunté/" books.csv
    # Enregistre l'emprunt dans emprunts.csv
    echo "$id_livre,$nom_emprunteur,$date_emprunt,$date_retour,emprunté" >> emprunts.csv
    echo "Livre avec ID $id_livre emprunté à $nom_emprunteur avec succès."
}

retourner_livre() {
    # demande l'ID du livre à retourner
    read -p "Entrez l'ID du livre à retourner : " id_livre
    grep -q "^$id_livre," books.csv
    if [ $? -ne 0 ]; then
        echo "Livre avec ID $id_livre non trouvé."
        return 1
    fi
    # Vérifie si le livre est emprunté
    statut=`grep "^$id_livre," books.csv | cut -d',' -f6 | tr -d '\r'`
    if [ "$statut" = "disponible" ]; then
        echo "Le livre avec ID $id_livre n'est pas emprunté."
        return 1
    fi
    # Remplace "emprunté" par "disponible" pour ce livre dans books.csv et par "rendu" dans emprunts.csv
    sed -i "/^$id_livre,/s/emprunté/disponible/" books.csv
    sed -i "/^$id_livre,/s/emprunté/rendu/" emprunts.csv 
    echo "Livre avec ID $id_livre retourné avec succès."
}

Livres_Empruntes() {
    #recherche des livres empruntés
    lignes=$(grep -i ",emprunté" books.csv)

    #si il n'y a aucun livres empruntés
    [ -z "$lignes" ] && echo "Aucun livre emprunté" && return

    #affichage des livres empruntés
    echo "---------------- Livres empruntés : ----------------"
    echo "$lignes" | while IFS=',' read -r id _; do
        afficheLivre "$id"
    done
}

Livres_en_retard() {
    today=$(date +%Y-%m-%d)
    if [ ! -f "emprunts.csv" ]; then
        echo "Aucun emprunt enregistré."
        return
    fi

    touch .livres_retard.tmp
    echo "---------------- Livres empruntés en retard : ----------------"
    #boucle sur chaque ligne d'emprunts.csv en vérifiant si le livre est en retard et emprunté
    tail -n +2 emprunts.csv | while IFS=',' read -r id_livre nom_emprunteur date_emprunt date_retour statut; do
        if [[ "$statut" = "emprunté" ]] && [[ "$date_retour" < "$today" ]]; then
            echo -e "Ce livre aurait du être retourné par $nom_emprunteur avant le $date_retour :"
            afficheLivre "$id_livre"
            echo "$id_livre" >> .livres_retard.tmp
        fi
    done

    if ! [ -s .livres_retard.tmp ]; then
        echo "Aucun livre en retard."
    fi
    rm -f .livres_retard.tmp
}

<<<<<<< HEAD
alerteLivreRetard() {
    today=$(date +%Y-%m-%d)
    if [ ! -f "emprunts.csv" ]; then
        return
    fi

    retard=0
    while IFS=',' read -r id_livre nom_emprunteur date_emprunt date_retour statut; do
        if [[ "$statut" = "emprunté" ]] && [[ "$date_retour" < "$today" ]]; then
            return 0 #0-> vrai en bash 
        fi
    done < <(tail -n +2 emprunts.csv) #Pas possible de mettre un pipe si return

    return 1
}

=======
>>>>>>> 4dce532ab48e8a8435fc12b2f5212c7fce569074
Historique_emprunts(){
    if [ ! -f "emprunts.csv" ]; then
        echo "Aucun emprunt enregistré."
        return
    fi

    echo "---------------- Historique des emprunts : ----------------"
    # Demande et vérifie l'ID (vide = tout afficher)
    while true; do
        read -p "ID du livre pour afficher l'historique (laisser vide pour tout afficher) : " id_recherche
        id_recherche=$(echo "$id_recherche" | tr -d '\r' | tr -s ' ')
        # on accepte champ vide
        [ -z "$id_recherche" ] && break
        # doit être numérique
        if ! [[ "$id_recherche" =~ ^[0-9]+$ ]]; then
            echo "ID invalide : doit être un nombre."
            continue
        fi
        # doit exister dans books.csv
        if ! grep -q "^${id_recherche}," books.csv; then
            echo "Aucun livre avec l'ID $id_recherche."
            continue
        fi
        # tout est OK
        break
    done

    tail -n +2 emprunts.csv | while IFS=',' read -r id_livre nom_emprunteur date_emprunt date_retour statut ; do
        # Affiche toutes les lignes si id_recherche vide, sinon seulement celles correspondant à l'ID demandé
        if [ -z "$id_recherche" ] || [ "$id_recherche" = "$id_livre" ]; then
            if [ "$statut" = "emprunté" ]; then
                if [ -z "$id_recherche" ]; then
                    echo "- Emprunt du livre "$id_livre" par "$nom_emprunteur" le "$date_emprunt" à rendre avant le "$date_retour" inclus."
                else
                    echo "- Emprunt par "$nom_emprunteur" le "$date_emprunt" à rendre avant le "$date_retour" inclus."
                fi
            else
                if [ -z "$id_recherche" ]; then
                    echo "- Emprunt du livre "$id_livre" par "$nom_emprunteur" le "$date_emprunt" rendu avant le "$date_retour" inclus."
                else
                    echo "- Emprunt par "$nom_emprunteur" le "$date_emprunt" rendu avant le "$date_retour" inclus."
                fi
            fi
        fi
    done
}



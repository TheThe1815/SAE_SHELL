#!/bin/bash

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
    if ! [[ "$3" =~ ^[0-9]{1,4}$ ]] || [ "$3" -gt $(date +%Y) ]; then
        echo "Erreur : L'année n'est pas valide."
        return  1
    fi

    if [ $(grep -q "$1" books.csv| wc -c ) -eq 0 ];
        then 
            echo "Livre deja existant"
            return  1
    fi
    echo "$id,$titre,$auteur,$annee,$genre,disponible" >> "books.csv"
    echo "Livre '$titre' ajouté avec succès."
}

# Modifie un livre
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

total_books() {
    local cpt_emprunts=$(wc -l < "emprunts.csv")
    local cpt_livres=$(wc -l < "books.csv")

    local nb_livres=$((cpt_emprunts+cpt_livres - 2))

    echo "Nombre total de livres dans la bibliothèque : $nb_livres dont $cpt_emprunts empruntés."
}

number_books_by_gender() {
    file="books.csv"

    local data_autors=$(tr -s ' ' "$file" | cut -d',' -f5  | grep -v "^Genre$" | sort | uniq -C)

    while read count genre
    do
        printf "%s [%s] : " "$genre" "$count"
        
        for ((i=0; i<$count; i++)); do
            printf "#"
        done
        
        printf "\n"

    done <<< "$data_gender" 
}

top_5_authors() {
    file="books.csv"

    local cpt=0
    local data_autors=$(tr -s ' ' "$file" | cut -d',' -f3  | grep -v "^Auteur$" | sort -nr | uniq -C)

    while read count auteur
    do 
        printf "Avec %s livres : %s \n" "$auteur" "$count"

        ((cpt++))
        if [ $cpt -eq 5 ] then break
    done <<< "$data_gender" 
}

books_by_decades() {
    file="books.csv"

    local data_years=$(tr -s ' ' "$file" | cut -d',' -f4  | grep -v "^Annee$" | sort | uniq -C)
    local cpt=0

    while read count annee
    do
        if [ $((annee%2))==0 && $(echo $annee | rev | cut -c1 | rev)==0 ] 
            ((cpt += count))
            then echo "$annee : $cpt"
            let cpt=0
        else cpt += count
    done <<< "$data_years"
}


# Exemple d'utilisation (à décommenter pour tester)
add_book "Mon Livre" "Moi" "2020" "SF" 
add_book "bible" "appotre" "50" "SF" 
add_book "bible" "appotre" "50" "SF" 
modify_book "Mon Livre" "Nouveau Titre" "Moi" "2021" "Policier" "Emprunté"
delbook "Nouveau Titre"
print_books
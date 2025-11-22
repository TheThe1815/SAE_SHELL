#!/bin/bash
source ./lib_functions.sh

menu_gestion_livres(){
    rep=0
    while [ "$rep" != 5 ]; do
        clear
        echo "========== Gestion des Livres =========="
        echo ""
        echo "--- Que voulez-vous faire ? --"
        echo "--- Ajouter un livre ?            tapez 1 ---"
        echo "--- Modifier un livre ?           taper 2 ---"
        echo "--- Supprimer un livre ?          taper 3 ---"
        echo "--- Lister des livres ?           taper 4 ---"
        echo "--- Return au menu principal ?    taper 5 ---"
        echo ""
        read -p "Votre choix ? : " choix

        case $choix in
            1) 
                clear
                continu=0
                while [ "$continu" != 1 ]; do
                    echo "_________ Ajout d'un livre _________"
                    read -p "Titre du livre ?  : " titre
                    read -p "Auteur du livre ? : " auteur
                    read -p "Annee du livre ?  : " annee
                    read -p "Genre du livre ?  : " genre
                    add_book "$titre" "$auteur" "$annee" "$genre" 
                    sleep 1
                    read -p "Voulez-vous ajouter un nouveau livre ? : (oui/non) 
" reponse
                    if [[ "$reponse" != 'oui' && "$reponse" != 'non' ]]; then
                        echo "Reponse invalide, retour au menu"
                        continu=1
                    fi
                    if [[ "$reponse" == 'non' ]]; then
                        continu=1
                    fi
                done;;

            2) 
                clear
                continu=0
                while [ "$continu" != 1 ]; do
                    echo "_________ Modif d'un livre _________"
                    read -p "Titre du livre a modifier ?  : " titre
                    read -p "Nouveau titre ?   : " newTitre
                    read -p "Nouveau auteur ?  : " newAuteur
                    read -p "Nouvelle annee ?  : " newAnnee
                    read -p "Nouveau genre ?   : " newGenre
                    newStatue="disponible"
                    modify_book "$titre" "$newTitre" "$newAuteur" "$newAnnee" "$newGenre" "$newStatue"
                    sleep 1
                    read -p "Voulez-vous modifier un autre livre ? : (oui/non) 
" reponse
                    if [[ "$reponse" != 'oui' && "$reponse" != 'non' ]]; then
                        echo "Reponse invalide, retour au menu"
                        continu=1
                    fi
                    if [[ "$reponse" == 'non' ]]; then
                        continu=1
                    fi
                done;;
            3)
                clear
                continu=0
                while [ "$continu" != 1 ]; do

                    echo "_________ Suppression d'un livre _________"
                    read -p "Titre du livre à supprimer ? : " titre
                    delbook "$titre" 
                    sleep 1
                    read -p "Voulez-vous supprimer un autre livre ? : (oui/non) 
" reponse
                    if [[ "$reponse" != 'oui' && "$reponse" != 'non' ]]; then
                        echo "Reponse invalide, retour au menu"
                        continu=1
                    fi
                    if [[ "$reponse" == 'non' ]]; then
                        continu=1
                    fi
                done;;

            4)
                print_books ;;

            5)
                rep=5 ;;

            *)
                echo "!!! Erreur de saisi !!!"
                echo "Veuillez entrez un nombre correct "
                sleep 1;;
        esac 
    done
}

menu_recherches_filtre(){
    rep=0 
    while [ "$rep" != 6 ]; do
        clear
        echo "========== Recherche et Filtres =========="
        echo ""
        echo "-- Que voulez-vous faire ? --"
        echo "--- Recherche par titre ?       taper 1 ---"
        echo "--- Recherche par auteur ?      taper 2 ---"
        echo "--- Recherche par genre ?       taper 3 ---"
        echo "--- Recherche par année ?       taper 4 ---"
        echo "--- Recherche avancée ?         taper 5 ---"
        echo "--- Retour au menu principal ?  taper 6 ---"
        echo ""
        read -p "Votre choix ? : " choix

        case $choix in
            1)
                continu=0
                while [ "$continu" != 1 ]; do
                    searchTitle
                    read -p "Voulez-vous rechercher un autre livre avec un titre ? : (oui/non) 
" reponse
                    if [[ "$reponse" != 'oui' && "$reponse" != 'non' ]]; then
                        echo "Reponse invalide, retour au menu"
                        continu=1
                        sleep 1
                    fi
                    if [[ "$reponse" == 'non' ]]; then
                        continu=1
                    fi
                done;;
            2)
                continu=0
                while [ "$continu" != 1 ]; do
                    searchAutor
                    read -p "Voulez-vous rechercher un autre livre avec un auteur ? : (oui/non) 
" reponse
                    if [[ "$reponse" != 'oui' && "$reponse" != 'non' ]]; then
                        echo "Reponse invalide, retour au menu"
                        sleep 1
                        continu=1
                    fi
                    if [[ "$reponse" == 'non' ]]; then
                        continu=1
                    fi
                done;;
            3) 
                continu=0
                while [ "$continu" != 1 ]; do
                    searchGender
                    read -p "Voulez-vous rechercher un autre livre avec le genre ? : (oui/non) 
" reponse
                    if [[ "$reponse" != 'oui' && "$reponse" != 'non' ]]; then
                        echo "Reponse invalide, retour au menu"
                        sleep 1
                        continu=1
                    fi
                    if [[ "$reponse" == 'non' ]]; then
                        continu=1
                    fi
                done;;
            4) 
                continu=0
                while [ "$continu" != 1 ]; do
                    searchYears
                    read -p "Voulez-vous rechercher un autre livre avec l'année ? : (oui/non) 
" reponse
                    if [[ "$reponse" != 'oui' && "$reponse" != 'non' ]]; then
                        echo "Reponse invalide, retour au menu"
                        sleep 1
                        continu=1
                    fi
                    if [[ "$reponse" == 'non' ]]; then
                        continu=1
                    fi
                done;;
            5) 
                continu=0
                while [ "$continu" != 1 ]; do
                    searchAll
                    read -p "Voulez-vous faire une rechercher avancee avec d'autre livre ? : (oui/non) 
" reponse
                    if [[ "$reponse" != 'oui' && "$reponse" != 'non' ]]; then
                        echo "Reponse invalide, retour au menu"
                        sleep 1
                        continu=1
                    fi
                    if [[ "$reponse" == 'non' ]]; then
                        continu=1
                    fi
                done;;
            6) 
                rep=6 ;;
            *) 
                echo "!!! Erreur de saisi !!!"
                echo "Veuillez entrez un nombre correct "
                sleep 1;;
        esac

    done
}

menu_stats(){
    rep=0
    while [ "$rep" != 5 ]; do
        clear
        echo "========== Statistiques =========="
        echo ""
        echo "-- Que voulez-vous afficher ? --"
        echo "--- Nombre total de livre ?                     taper 1 ---"
        echo "--- Repartition par genre ?                     taper 2 ---"
        echo "--- Le Top 5 des auteurs les plus présents ?   taper 3 ---"
        echo "--- Livres par décennie ?                       taper 4 ---"
        echo "--- Retour au menu principal ?                  taper 5 ---"
        echo ""
        read -p "Votre choix ? : " choix
        clear

        case "$choix" in
            1)
                total_books
                read -p "Appuyez sur une touche pour continuer..." -n1 -s ;;
            2)
                number_books_by_gender
                read -p "Appuyez sur une touche pour continuer..." -n1 -s ;;
            3)
                top_5_authors
                read -p "Appuyez sur une touche pour continuer..." -n1 -s ;;
            4)
                books_by_decades
                read -p "Appuyez sur une touche pour continuer..." -n1 -s ;;
            5)
                rep=5;;
            *)
                echo "!!! Erreur de saisi !!!"
                echo "Veuillez entrez un nombre correct "
                sleep 1;;
        esac
    done
}

menu_emprunts(){
    rep=0
    while [ "$rep" != 6 ]; do
        clear
        echo "========== Emprunts =========="
        echo ""
        echo "-- Que voulez-vous faire ? --"
        echo "--- Emprunter un livre ?               taper 1 ---"
        echo "--- Retourner un livre ?               taper 2 ---"
        echo "--- Lister les livres empruntés ?     taper 3 ---"
        echo "--- Lister les livres en retard ?     taper 4 ---"
        echo "--- Historique des emprunts ?         taper 5 ---"
        echo "--- Retour au menu principal ?        taper 6 ---"
        echo ""
        read -p "Votre choix ? : " choix
        clear

        case "$choix" in
            1)
                emprunter_livre
                read -p "Appuyez sur une touche pour continuer..." -n1 -s ;;
            2)
                retourner_livre
                read -p "Appuyez sur une touche pour continuer..." -n1 -s ;;
            3)
                Livres_Empruntes
                read -p "Appuyez sur une touche pour continuer..." -n1 -s ;;
            4)
                Livres_en_retard
                read -p "Appuyez sur une touche pour continuer..." -n1 -s ;;
            5)
                Historique_emprunts
                read -p "Appuyez sur une touche pour continuer..." -n1 -s ;;
            6)
                rep=6;;
            *)
                echo "!!! Erreur de saisi !!!"
                echo "Veuillez entrez un nombre correct "
                sleep 1;;
        esac
    done
}


# -------------- MENU PRINCIPAL ------------

quitter=1
while [ "$quitter" != 0 ]; do
    clear
    echo "---- Bienvenue dans notre Bibliothèque interactive ----"
    echo "============= Que souhaitez vous faire ? ============= "
    echo " Gestion des livres :     tapez 1"
    echo " Recherche et filtres :    tapez 2"
    echo " Statistiques :           tapez 3"
    echo " Emprunts :               tapez 4"
    echo " Quittez :                tapez 5"
    read -p "Votre choix ? : " principalChoix

    case "$principalChoix" in
        1) 
            menu_gestion_livres ;;
        2)
            menu_recherches_filtre ;;
        3)
            menu_stats ;;
        4)
            menu_emprunts ;;
        5)
            quitter=0 ;;    
        *)
            echo "!!! Erreur de saisi !!!"
            echo "Veuillez entrez un nombre correct " 
            sleep 1;;
    esac
done
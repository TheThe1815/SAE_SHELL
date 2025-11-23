#!/bin/bash
source ./lib_functions.sh

menu_gestion_livres(){
    rep=0
    while [ "$rep" != 1 ]; do
        clear
        echo "========== Gestion des Livres =========="
        echo ""
        echo "--- Que voulez-vous faire ? --"
        echo "--- Ajouter un livre ?            tapez 1 ---"
        echo "--- Modifier un livre ?           taper 2 ---"
        echo "--- Supprimer un livre ?          taper 3 ---"
        echo "--- Lister des livres ?           taper 4 ---"
        echo "--- Retour au menu principal (q)? taper 5 ---"
        echo ""
        echo "============= Votre choix ? ============"
        echo ""
        read -n 1 -s choix

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
                    echo "Voulez-vous ajouter un autre livre ? : (y/n) "
                    while true; do
                        read -n 1 -s -r reponse
                        [ "$reponse" == 'n' ] && continu=1 && break
                        [ "$reponse" == 'y' ] && break
                    done
                done
                ;;

            2) 
                clear
                continu=0
                while [ "$continu" != 1 ]; do
                    echo "_________ Modification d'un livre _________"
                    read -p "Titre du livre a modifier ?  : " titre
                    read -p "Nouveau titre ?   : " newTitre
                    read -p "Nouveau auteur ?  : " newAuteur
                    read -p "Nouvelle annee ?  : " newAnnee
                    read -p "Nouveau genre ?   : " newGenre
                    modify_book "$titre" "$newTitre" "$newAuteur" "$newAnnee" "$newGenre"
                    sleep 1
                    echo "Voulez-vous modifier un autre livre ? : (y/n) "
                    while true; do
                        read -n 1 -s -r reponse
                        [ "$reponse" == 'n' ] && continu=1 && break
                        [ "$reponse" == 'y' ] && break
                    done
                done
                ;;
            3)
                clear
                continu=0
                while [ "$continu" != 1 ]; do

                    echo "_________ Suppression d'un livre _________"
                    read -p "Titre du livre à supprimer ? : " titre
                    delbook "$titre" 
                    sleep 1
                    echo "Voulez-vous supprimer un autre livre ? : (y/n) "
                    while true; do
                        read -n 1 -s -r reponse
                        [ "$reponse" == 'n' ] && continu=1 && break
                        [ "$reponse" == 'y' ] && break
                    done
                done
                ;;

            4)
                print_books 
                ;;
            5)
                rep=1
                ;;
            q)
                rep=1 
                ;;

            *)
                :
                ;;
        esac 
    done
}

menu_recherches_filtre(){
    rep=0 
    while [ "$rep" != 1 ]; do
        clear
        echo "========== Recherche et Filtres =========="
        echo ""
        echo "-- Que voulez-vous faire ? --"
        echo "--- Recherche par titre ?           taper 1 ---"
        echo "--- Recherche par auteur ?          taper 2 ---"
        echo "--- Recherche par genre ?           taper 3 ---"
        echo "--- Recherche par année ?           taper 4 ---"
        echo "--- Recherche avancée ?             taper 5 ---"
        echo "--- Retour au menu principal (q) ?  taper 6 ---"
        echo ""
        echo "============= Votre choix ? ============"
        echo ""
        read -n 1 -s choix
        clear
        case $choix in
            1)
                continu=0
                while [ "$continu" != 1 ]; do
                    searchTitle
                    echo "Voulez-vous rechercher un autre livre avec le titre ? : (y/n) "
                    while true; do
                        read -n 1 -s -r reponse
                        [ "$reponse" == 'n' ] && continu=1 && break
                        [ "$reponse" == 'y' ] && break
                    done
                done
                ;;
            2)
                continu=0
                while [ "$continu" != 1 ]; do
                    searchAuthor
                    echo "Voulez-vous rechercher un autre livre avec son auteur ? : (y/n) "
                    while true; do
                        read -n 1 -s -r reponse
                        [ "$reponse" == 'n' ] && continu=1 && break
                        [ "$reponse" == 'y' ] && break
                    done
                done
                ;;
            3) 
                continu=0
                while [ "$continu" != 1 ]; do
                    searchGender
                    echo "Voulez-vous rechercher un autre livre avec son genre ? : (y/n) "
                    while true; do
                        read -n 1 -s -r reponse
                        [ "$reponse" == 'n' ] && continu=1 && break
                        [ "$reponse" == 'y' ] && break
                    done
                done
                ;;
            4) 
                continu=0
                while [ "$continu" != 1 ]; do
                    searchYears
                    echo "Voulez-vous rechercher un autre livre avec les années ? : (y/n) "
                    while true; do
                        read -n 1 -s -r reponse
                        [ "$reponse" == 'n' ] && continu=1 && break
                        [ "$reponse" == 'y' ] && break
                    done
                done
                ;;
            5) 
                continu=0
                while [ "$continu" != 1 ]; do
                    searchAll
                    echo "Voulez-vous rechercher un autre livre avec plusieurs criteres ? : (y/n) "
                    while true; do
                        read -n 1 -s -r reponse
                        [ "$reponse" == 'n' ] && continu=1 && break
                        [ "$reponse" == 'y' ] && break
                    done
                done
                ;;
            q) 
                rep=1 
                ;;
            6)
                rep=1 
                ;;
            *) 
                :
                ;;
        esac

    done
}

menu_stats(){
    rep=0
    while [ "$rep" != 1 ]; do
        clear
        echo "========== Statistiques =========="
        echo ""
        echo "-- Que voulez-vous afficher ? --"
        echo "--- Nombre total de livre ?                     taper 1 ---"
        echo "--- Repartition par genre ?                     taper 2 ---"
        echo "--- Le Top 5 des auteurs les plus présents ?    taper 3 ---"
        echo "--- Livres par décennie ?                       taper 4 ---"
        echo "--- Enregistrer les resultats dans un PDF ?     taper 5 ---"
        echo "--- Retour au menu principal (q) ?              taper 6 ---"
        echo ""
        echo "============= Votre choix ? ============"
        echo ""
        read -n 1 -s choix


        case "$choix" in
            1)
                continu=0
                total_books
                echo "(q) pour quitter "
                while [ "$continu" != 1 ]; do
                    read -n 1 -s -r reponse
                    if [ "$reponse" == 'q' ]; then
                        continu=1
                    fi
                done
                ;;

            2)
                continu=0
                number_books_by_gender
                echo "(q) pour quitter "
                while [ "$continu" != 1 ]; do
                    read -n 1 -s -r reponse
                    if [ "$reponse" == 'q' ]; then
                        continu=1
                    fi
                done
                ;;
            3)
                continu=0
                top_5_authors
                echo "(q) pour quitter "
                while [ "$continu" != 1 ]; do
                    read -n 1 -s -r reponse
                    if [ "$reponse" == 'q' ]; then
                        continu=1
                    fi
                done
                ;;
            4)
                continu=0
                books_by_decades
                echo "(q) pour quitter "
                while [ "$continu" != 1 ]; do
                    read -n 1 -s -r reponse
                    if [ "$reponse" == 'q' ]; then
                        continu=1
                    fi
                done
                ;;
            5)
                enscript_format
                sleep 10
                ;;
            6)
                rep=1 
                ;;
            q)
                rep=1
                ;;
            *)
                :
                ;;
        esac
    done
}

menu_emprunts(){
    rep=0
    while [ "$rep" != 1 ]; do
        clear
        echo "========== Emprunts =========="
        echo ""
        echo "-- Que voulez-vous faire ? --"
        echo "--- Emprunter un livre ?              taper 1 ---"
        echo "--- Retourner un livre ?              taper 2 ---"
        echo "--- Lister les livres empruntés ?     taper 3 ---"
        echo "--- Lister les livres en retard ?     taper 4 ---"
        echo "--- Historique des emprunts ?         taper 5 ---"
        echo "--- Retour au menu principal (q) ?    taper 6 ---"
        echo ""
        echo "============= Votre choix ? ============"
        echo ""
        read -n 1 -s choix


        case "$choix" in
            1)
                emprunter_livre
                sleep 2
                ;;

            2)
                retourner_livre
                sleep 2
                ;;

            3)
                continu=0
                Livres_Empruntes
                echo "(q) pour quitter "
                while [ "$continu" != 1 ]; do
                    read -n 1 -s -r reponse
                    if [ "$reponse" == 'q' ]; then
                        continu=1
                    fi
                done
                ;;
            4)
                continu=0
                Livres_en_retard
                echo "(q) pour quitter "
                while [ "$continu" != 1 ]; do
                    read -n 1 -s -r reponse
                    if [ "$reponse" == 'q' ]; then
                        continu=1
                    fi
                done
                ;;
            5)
                continu=0
                while [ "$continu" != 1 ]; do
                    Historique_emprunts
                    echo "Voulez-vous un autre historique d'emprunt ? : (y/n) "
                    while true; do
                        read -n 1 -s -r reponse
                        [ "$reponse" == 'n' ] && continu=1 && break
                        [ "$reponse" == 'y' ] && break
                    done
                done
                ;;
            6)
                rep=1 
                ;;
            q)
                rep=1 
                ;;
            *)
                :
                ;;
        esac
    done
}


# -------------- MENU PRINCIPAL ------------

quitter=0
while [ "$quitter" != 1 ]; do
    clear
    echo "---- Bienvenue dans notre Bibliothèque interactive ----"
    echo "============= Que souhaitez vous faire ? ============= "
    echo " Gestion des livres :     tapez 1"
    echo " Recherche et filtres :   tapez 2"
    echo " Statistiques :           tapez 3"
    echo " Emprunts :               tapez 4"
    echo " Quittez (q) :            tapez 5"
    if alerteLivreRetard; then #Si la condition est une fonction pas de []
        echo "==================================================="
        echo "Attention il y a du retard dans les emprunts"
    fi
    echo "============= Votre choix ? ============"
    echo ""
    read -n 1 -s principalChoix

    case "$principalChoix" in
        1) 
            menu_gestion_livres 
            ;;
        2)
            menu_recherches_filtre 
            ;;
        3)
            menu_stats 
            ;;
        4)
            menu_emprunts 
            ;;
        5)
            quitter=1 
            ;;
        q)
            quitter=1 
            ;;    
        *)
            :
            ;;
    esac
done
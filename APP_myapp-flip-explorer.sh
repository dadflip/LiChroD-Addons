#!/bin/bash

# Fonction pour afficher un menu avec yad
show_menu() {
    choice=$(yad --list \
        --title="Menu" \
        --text="Sélectionnez une option :" \
        --column="Option" \
        "Option 1" \
        "Option 2" \
        "Option 3" \
        "Quitter")

    case "$choice" in
        "Option 1")
            yad --info --text="Vous avez choisi l'Option 1" --title="Option 1"
            show_menu
            ;;
        "Option 2")
            yad --info --text="Vous avez choisi l'Option 2" --title="Option 2"
            show_menu
            ;;
        "Option 3")
            yad --info --text="Vous avez choisi l'Option 3" --title="Option 3"
            show_menu
            ;;
        "Quitter")
            yad --info --text="Au revoir !" --title="Quitter"
            ;;
        *)
            yad --error --text="Option invalide" --title="Erreur"
            show_menu
            ;;
    esac
}

show_menu

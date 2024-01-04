#!/bin/bash

# Demander à l'utilisateur de sélectionner le mode d'exécution
execution_mode=$(zenity --list --radiolist \
    --title="Mode d'execution" \
    --text="Selectionnez le mode d'execution :" \
    --column="Selection" --column="Mode" \
    FALSE "Utilisateur normal" \
    FALSE "sudo" \
    FALSE "su (connexion en root)")

# Vérifier si l'utilisateur a annulé la sélection
if [ $? -eq 1 ]; then
    exit
fi

# Demander le mot de passe si le mode choisi est "su"
if [ "$execution_mode" == "su (connexion en root)" ]; then
    root_password=$(zenity --password \
        --title="Mot de passe root" \
        --text="Entrez le mot de passe root pour la connexion en root :")
fi

# Liste des fichiers exécutables dans /usr/bin
executable_files=$(find /usr/bin -type f -executable)

# Créer une liste d'options pour Zenity
options=""
for file in $executable_files; do
    options+="FALSE $(basename "$file") "
done

# Demander à l'utilisateur de sélectionner une option
selected_option=$(zenity --list --checklist \
    --title="Selectionner un executable" \
    --text="Selectionnez un ou plusieurs executable(s):" \
    --column="Selection" --column="Fichier" \
    $options \
    --separator=" ")

# Vérifier si l'utilisateur a annulé la sélection
if [ $? -eq 1 ]; then
    exit
fi

# Demander à l'utilisateur de saisir des flags et options
flags_and_options=$(zenity --entry \
    --title="Saisir les flags et options" \
    --text="Entrez les flags et options pour la commande selectionnee :")

# Exécuter les fichiers sélectionnés avec les flags et options et en fonction du mode d'exécution
for option in $selected_option; do
    file="/usr/bin/$option"
    case "$execution_mode" in
        "Utilisateur normal")
            "$file" $flags_and_options
            ;;
        "sudo")
            sudo "$file" $flags_and_options
            ;;
        "su (connexion en root)")
            echo "$root_password" | su -c "$file $flags_and_options"
            ;;
    esac
done


echo "TERMINE"
#!/bin/bash

# Lire les commandes du fichier sélectionné
read_commands() {
if [ -f "$1" ]; then
commands=$(cat "$1" | iconv -f utf-8 -t ascii//TRANSLIT | sort -u)
else
commands=""
fi
}

# Lire les fichiers .flip dans le répertoire
read_flip_files() {
flip_files=($(find "$flip_dir" -type f -name "*.flip" -print))
}



# Vérifier si le programme "yad" est installé
if ! command -v yad &> /dev/null; then
    echo "Ce script nécessite le programme 'yad' pour fonctionner."
    echo "Vous pouvez l'installer avec : sudo apt-get install yad"
    exit 1
fi

# Répertoire de stockage des fichiers .flip
flip_dir="$HOME/.flip"
flip_file="$flip_dir/commands.flip"

# Créer le répertoire s'il n'existe pas
mkdir -p "$flip_dir"

# Menu pour choisir entre l'enregistrement et l'ouverture
mode_choice=$(yad --list \
                  --title="Mode d'utilisation de FlipScript" \
                  --text="Choisissez le mode d'utilisation :" \
                  --column="Mode" \
                  "Enregistrement" \
                  "Ouverture" \
                  "Executer"\
                  --width=300 \
                  --height=200 \
                  --button="Annuler:1" \
                  --button="Continuer:0")

echo $mode_choice

if [ -z "$mode_choice" ]; then
    exit 0
fi

if [ "$mode_choice" = "Enregistrement|" ]; then
    # Ouvrir un éditeur de texte pour entrer la commande
    new_command=$(yad --title="Enregistrer une nouvelle commande" \
                      --text-info \
                      --editable \
                      --width=500 \
                      --height=300 \
                      --button="Annuler:1" \
                      --button="Enregistrer:0")

    if [ -z "$new_command" ]; then
        exit 0
    fi

    # Écrire la commande dans le fichier .flip
    echo "$new_command" >> "$flip_file"
    echo "Commande enregistrée avec succès dans $flip_file"
    
elif [ "$mode_choice" = "Executer|" ]; then

    # Vérifier si le fichier .flip existe
    if [ -f "$flip_file" ]; then
        # Lire les commandes du fichier .flip
        read_commands "$flip_file"

        # Sélectionner une commande à exécuter
        selected_command=$(echo "$commands" | yad --list \
                                                  --title="Liste des commandes enregistrees" \
                                                  --text="Selectionnez une commande :" \
                                                  --column="Commande" \
                                                  --width=300 \
                                                  --height=300 \
                                                  --button="Fermer:1")

        # Exécuter la commande sélectionnée si elle est non vide
        if [ -n "$selected_command" ]; then
            cleaned_command=$(echo "$selected_command" | sed 's/|//g')
            eval "$cleaned_command"
        fi
    else
        echo "Le fichier $flip_file n'existe pas. Enregistrez des commandes d'abord."
    fi

else
    # Ouverture d'un fichier .flip existant
    

    # Lire les fichiers .flip
    read_flip_files

    # Sélectionner un fichier .flip à utiliser
    selected_flip_file=$(yad --file-selection \
                             --title="Selectionner un fichier .flip" \
                             --file-filter="Fichiers .flip (*.flip) | *.flip" \
                             --width=500 \
                             --height=300 \
                             --button="Annuler:1" \
                             --button="Selectionner:0")

    if [ -z "$selected_flip_file" ]; then
        exit 0
    fi


    read_commands "$selected_flip_file"

    # Afficher une liste sélectionnable des commandes
    selected_command=$(echo "$commands" | yad --list \
                                              --title="Liste des commandes enregistrees" \
                                              --text="Selectionnez une commande :" \
                                              --column="Commande" \
                                              --width=300 \
                                              --height=300 \
                                              --button="Fermer:1")

    echo "$selected_command"
    # Exécuter la commande sélectionnée si elle est non vide
    if [ -n "$selected_command" ]; then
        cleaned_command=$(echo "$selected_command" | sed 's/|//g')
        terminator -e "bash -c 'eval \"$cleaned_command\" && read'"
    fi

fi

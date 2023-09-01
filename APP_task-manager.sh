#!/bin/bash

# Liste des paquets nécessaires
required_packages=("nnn" "task" "tmux" "terminator")

# Vérifier si les paquets sont installés
missing_packages=()
for package in "${required_packages[@]}"; do
    if ! dpkg -l | grep -q "ii  $package"; then
        missing_packages+=("$package")
    fi
done

if [ ${#missing_packages[@]} -gt 0 ]; then
    echo "Les paquets suivants sont nécessaires mais ne sont pas installés :"
    for package in "${missing_packages[@]}"; do
        echo "- $package"
    done

    read -p "Voulez-vous installer automatiquement ces paquets ? (y/n): " choice
    if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
        sudo apt-get update
        sudo apt-get install -y "${missing_packages[@]}"
        echo "Paquets installés avec succès !"
    else
        echo "Veuillez les installer manuellement et réessayer."
    fi

    exit 1
fi

# Emplacement du répertoire de tâches
TASK_DIR="$HOME/tasks"

# Vérifier si le répertoire de tâches existe, sinon le créer
if [ ! -d "$TASK_DIR" ]; then
    mkdir -p "$TASK_DIR"
fi

# Exécuter les commandes dans Terminator via tmux
tmux new-session -d -s "task_script" \; \
    split-window -v -p 50 \; \
    send-keys "bash -c '
        # Afficher la liste des tâches à l'aide de nnn
        selected_task=\$(ls \"$TASK_DIR\" | nnn -P -d)

        # Ajouter la tâche sélectionnée à Taskwarrior
        if [ -n \"\$selected_task\" ]; then
            task_description=\$(cat \"$TASK_DIR/\$selected_task\")
            task add \"\$task_description\"
            echo \"Tâche ajoutée à Taskwarrior : \$task_description\"
        else
            echo \"Aucune tâche sélectionnée.\"
        fi
        exec bash
    '" C-m \; \
    send-keys "exec bash" C-m \; \
    select-pane -t 0 \; \
    attach-session -d -t "task_script"

#!/bin/bash

# Liste des paquets nécessaires
required_packages=("apg" "figlet" "lolcat")

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

fi

# Générer un mot de passe aléatoire avec "apg"
random_password=$(apg -n 1 -m 16 -x 20 -M NCL)

# Afficher le mot de passe en ASCII avec "figlet" et "lolcat"
echo "$random_password" | figlet | lolcat

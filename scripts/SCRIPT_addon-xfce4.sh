#!/bin/bash

# Création d'un fichier temporaire pour le script
temp_script=$(mktemp)
cat << 'EOF' > "$temp_script"
#!/bin/bash

# Vérifier si l'utilisateur a les privilèges d'administration
if [ "$EUID" -ne 0 ]; then
  echo "Ce script doit être exécuté en tant qu'administrateur (root)."
  exit 1
fi

# Mise à jour des informations sur les paquets
apt update

# Installation de l'ensemble complet d'outils XFCE4
apt install -y xfce4

# Vérification de la réussite de l'installation
if [ $? -eq 0 ]; then
  echo "L'ensemble complet d'outils XFCE4 a été installé avec succès."
else
  echo "Une erreur s'est produite lors de l'installation de l'ensemble complet d'outils XFCE4."
fi
EOF

# Affichage du script dans une fenêtre Zenity interactive
zenity --text-info --filename="$temp_script" --editable

# Nettoyage du fichier temporaire
rm "$temp_script"

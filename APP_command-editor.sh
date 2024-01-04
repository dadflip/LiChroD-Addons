#!/bin/bash

# Demander le nom de la commande
command_name=$(yad --title="Creer une nouvelle commande" \
                  --text="Entrez le nom de la nouvelle commande :" \
                  --entry \
                  --width=300 \
                  --button="Annuler:1" \
                  --button="Continuer:0")

# Vérifier si l'utilisateur a annulé
if [ $? -eq 1 ]; then
    yad --info --text="Operation annulee." --title="Annule"
    exit 0
fi

# Demander le contenu de la commande
command_content=$(yad --title="Contenu de la commande" \
                      --text-info \
                      --editable \
                      --width=600 \
                      --height=400 \
                      --button="Annuler:1" \
                      --button="Enregistrer:0")

# Vérifier si l'utilisateur a annulé
if [ $? -eq 1 ]; then
    yad --info --text="Operation annulee." --title="Annule"
    exit 0
fi

# Créer le fichier de la commande
command_file="/usr/local/bin/$command_name"
echo -e "#!/bin/bash\n$command_content" | sudo tee "$command_file" > /dev/null
sudo chmod +x "$command_file"

yad --info --text="La commande \"$command_name\" a ete creee avec succes !" --title="Termine"

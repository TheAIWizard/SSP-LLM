#!/bin/sh

# Check if required arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <destination_path> <model_url>"
    exit 1
fi

DESTINATION="$1"
MODEL_URL="$2"

# Création du répertoire de destination s'il n'existe pas
sudo mkdir -p "$(dirname "$DESTINATION")"

# Téléchargement du modèle avec curl
sudo curl -L -o "$DESTINATION" "$MODEL_URL"

# Vérification du téléchargement
if [ $? -eq 0 ]; then
    echo "Modèle téléchargé avec succès dans $DESTINATION"
else
    echo "Échec du téléchargement du modèle"
    exit 1
fi

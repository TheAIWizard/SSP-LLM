#!/bin/sh

DESTINATION="zephyr-7b-beta.Q8_0.gguf"
MODEL_URL="https://huggingface.co/TheBloke/zephyr-7B-beta-GGUF/resolve/main/zephyr-7b-beta.Q8_0.gguf"

# Création du répertoire de destination s'il n'existe pas
sudo mkdir -p "$(dirname "$DESTINATION")"

# Téléchargement du modèle avec curl
sudo curl -o "$DESTINATION" "$MODEL_URL"

# Vérification du téléchargement
if [ $? -eq 0 ]; then
    echo "Modèle téléchargé avec succès dans $DESTINATION"
else
    echo "Échec du téléchargement du modèle"
    exit 1
fi

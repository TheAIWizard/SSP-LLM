import os
import urllib.request


def download_model():
    # Check if required environment variables are set
    model_name = os.environ.get("MODEL_NAME")
    model_url = os.environ.get("MODEL_URL")

    if not model_name or not model_url:
        print("Error: MODEL_NAME and MODEL_URL must be set " 
              "as environment variables.")
        return

    # Create the destination directory if it does not exist
    os.makedirs(os.path.dirname(model_name), exist_ok=True)

    # Download the model with urllib
    try:
        urllib.request.urlretrieve(
            model_url,
            model_name
        )
        print("Modèle téléchargé avec succès dans", model_name)
    except Exception as e:
        print("Échec du téléchargement du modèle:", str(e))


if __name__ == "__main__":
    download_model()

#!/bin/bash

# Variables de configuration
RESOURCE_GROUP="rg-terraform-state"
STORAGE_ACCOUNT="stterraformstatebackend"
CONTAINER_NAME="tfstate"
LOCATION="francecentral"

echo "🔄 Création du Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "📦 Création du Storage Account..."
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --encryption-services blob \
  --allow-blob-public-access false

# Pause pour laisser Azure créer le storage account
echo "⏳ Attente de la création du storage account..."
sleep 10

echo "🔑 Récupération de la clé d'accès..."
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP \
  --account-name $STORAGE_ACCOUNT \
  --query '[0].value' --output tsv)

if [ -z "$ACCOUNT_KEY" ]; then
    echo "❌ Erreur : Impossible de récupérer la clé du storage account"
    exit 1
fi

echo "🔍 Vérification de l'existence du container..."
if az storage container show \
    --name $CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT \
    --account-key $ACCOUNT_KEY &>/dev/null; then
    echo "✅ Le container existe déjà"
else
    echo "🗂️ Création du container de state..."
    az storage container create \
        --name $CONTAINER_NAME \
        --account-name $STORAGE_ACCOUNT \
        --account-key $ACCOUNT_KEY

    # Vérification que le container a bien été créé
    if ! az storage container show \
        --name $CONTAINER_NAME \
        --account-name $STORAGE_ACCOUNT \
        --account-key $ACCOUNT_KEY &>/dev/null; then
        echo "❌ Erreur : Le container n'a pas pu être créé"
        exit 1
    fi
fi

echo "✅ Backend Azure Terraform prêt à l'emploi 🎉"

# Afficher les informations de connexion pour vérification
echo "
🔍 Informations du backend :
- Resource Group : $RESOURCE_GROUP
- Storage Account : $STORAGE_ACCOUNT
- Container : $CONTAINER_NAME
"

#!/bin/bash

# Variables de configuration
RESOURCE_GROUP="rg-terraform-state"
STORAGE_ACCOUNT="stterraformstatebackend"
CONTAINER_NAME="tfstate"
LOCATION="westeurope"

echo "🔄 Création du Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "📦 Création du Storage Account..."
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --encryption-services blob

echo "🔑 Récupération de la clé d'accès..."
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP \
  --account-name $STORAGE_ACCOUNT \
  --query '[0].value' --output tsv)

echo "🗂️ Création du container de state..."
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT \
  --account-key $ACCOUNT_KEY

echo "✅ Backend Azure Terraform prêt à l'emploi 🎉"

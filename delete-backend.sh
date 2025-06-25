#!/bin/bash

# Nom du Resource Group utilisé pour le backend Terraform
RESOURCE_GROUP="rg-terraform-state"

echo "⚠️ ATTENTION : ceci va supprimer définitivement le resource group '$RESOURCE_GROUP' et tout ce qu'il contient !"
read -p "Confirmer (y/n) ? " CONFIRM

if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
  echo "🔨 Suppression du Resource Group..."
  az group delete --name $RESOURCE_GROUP --yes --no-wait
  echo "🗑️ Suppression demandée. Cela peut prendre quelques minutes."
else
  echo "❌ Opération annulée."
fi

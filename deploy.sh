#!/bin/bash

# VARIABLES
LOCATION="westeurope"
RG_NAME="IAM-Project-RG"
VNET_NAME="IAM-VNET"
WEB_SUBNET="Web-Subnet"
DB_SUBNET="DB-Subnet"

VNET_ADDRESS="10.0.0.0/16"
WEB_SUBNET_PREFIX="10.0.1.0/24"
DB_SUBNET_PREFIX="10.0.2.0/24"

echo "Creating Resource Group..."
az group create \
  --name $RG_NAME \
  --location $LOCATION

echo "Creating Virtual Network..."
az network vnet create \
  --resource-group $RG_NAME \
  --name $VNET_NAME \
  --address-prefix $VNET_ADDRESS

echo "Creating Web Subnet..."
az network vnet subnet create \
  --resource-group $RG_NAME \
  --vnet-name $VNET_NAME \
  --name $WEB_SUBNET \
  --address-prefix $WEB_SUBNET_PREFIX

echo "Creating DB Subnet..."
az network vnet subnet create \
  --resource-group $RG_NAME \
  --vnet-name $VNET_NAME \
  --name $DB_SUBNET \
  --address-prefix $DB_SUBNET_PREFIX

echo "Network deployment complete."

echo "Creating Azure AD Groups..."

az ad group create \
  --display-name "WebAdmins" \
  --mail-nickname "WebAdmins"

az ad group create \
  --display-name "DBAdmins" \
  --mail-nickname "DBAdmins"

echo "Groups created."

DB_SUBNET_ID=$(az network vnet subnet show \
  --resource-group $RG_NAME \
  --vnet-name $VNET_NAME \
  --name $DB_SUBNET \
  --query id \
  --output tsv)

echo "DB Subnet ID: $DB_SUBNET_ID"

DBADMINS_ID=$(az ad group show \
  --group "DBAdmins" \
  --query id \
  --output tsv)

echo "DBAdmins Object ID: $DBADMINS_ID"

echo "Assigning Reader role to DBAdmins..."

az role assignment create \
  --assignee-object-id $DBADMINS_ID \
  --assignee-principal-type Group \
  --role "Reader" \
  --scope $DB_SUBNET_ID

echo "Role assignment complete."

echo "Creating Test Users..."

az ad user create \
  --display-name "Web Test User" \
  --user-principal-name webtestuser@franksonwebsteryahoo.onmicrosoft.com \
  --password "P@ssword1234!" \
  --force-change-password-next-sign-in true


az ad user create \
  --display-name "DB Test User" \
  --user-principal-name dbtestuser@franksonwebsteryahoo.onmicrosoft.com \
  --password "P@ssword1234!" \
  --force-change-password-next-sign-in true

  WEBADMINS_ID=$(az ad group show --group "WebAdmins" --query id --output tsv)

WEBUSER_ID=$(az ad user show --id webtestuser@franksonwebsteryahoo.onmicrosoft.com --query id --output tsv)
DBUSER_ID=$(az ad user show --id dbtestuser@franksonwebsteryahoo.onmicrosoft.com --query id --output tsv)

az ad group member add --group $WEBADMINS_ID --member-id $WEBUSER_ID
az ad group member add --group $DBADMINS_ID --member-id $DBUSER_ID
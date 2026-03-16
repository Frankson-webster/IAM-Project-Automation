#!/bin/bash

echo "Removing Role Assignment..."

az role assignment delete \
  --assignee $DBADMINS_ID \
  --role "Reader" \
  --scope $DB_SUBNET_ID

echo "Deleting Resource Group..."

az group delete \
  --name $RG_NAME \
  --yes \
  --no-wait

echo "Cleanup initiated."

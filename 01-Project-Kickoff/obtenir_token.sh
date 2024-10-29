#!/bin/bash
CLIENT_ID="PAR_mappingjoboffersinfra_096a877d64f6f044ec6c11738a8149b5d3021e6d407bd680fa261bd850342c92"
CLIENT_SECRET="0155502fb4c6bdd02e11a514ea40b7e22fe155b208df5e73b990edd3d764ccc4"

REALM='%2Fpartenaire'
SCOPE='api_offresdemploiv2%20o2dsoffre'

RESPONSE=$(curl --request POST \
  --url "https://entreprise.pole-emploi.fr/connexion/oauth2/access_token?realm=$REALM" \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data "grant_type=client_credentials&client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&scope=$SCOPE")

echo "Réponse du serveur : $RESPONSE"

# 1. run "chmod +x obtenir_token.sh" in a zsh terminal to make this script executable
# 2. run "./obtenir_token.sh" in a bash terminal to execute it and get a token back
# 3. update the token in the .env file with the new "access_token" generated in step 2
# 4. run "poetry run start" to start the server

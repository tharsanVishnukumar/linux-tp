#!/bin/bash

if [ "$USER" != "root" ]; then
  echo "Erreur : Vous devez être 'root' pour exécuter ce script."
  exit 1
fi

read -p "Entrez le login : " login
read -p "Entrez le Nom : " nom
read -p "Entrez le Prénom : " prenom
read -p "Entrez l'UID souhaité : " uid
read -p "Entrez le GID (groupe principal) : " gid
read -p "Entrez des commentaires : " commentaires

login_existant=$(getent passwd "$login" | cut -d: -f3)
uid_existant=$(getent passwd "$uid" | cut -d: -f3)

if [ -n "$login_existant" ]; then
  echo "Opération annulée : Le login '$login' existe déjà (UID: $login_existant)."
  exit 1
fi

if [ -n "$uid_existant" ]; then
  echo "Opération annulée : L'UID '$uid' est déjà attribué."
  exit 1
fi

repertoire_home="/home/$login"
if [ -d "$repertoire_home" ]; then
  echo "Opération annulée : Le répertoire $repertoire_home existe déjà sur le système."
  exit 1
fi

useradd -u "$uid" -g "$gid" -c "$prenom $nom, $commentaires" -d "$repertoire_home" -m "$login"

if [ $? -eq 0 ]; then
  echo "Succès : L'utilisateur $login a été créé avec le répertoire $repertoire_home."
else
  echo "Erreur système lors de la création de l'utilisateur."
  exit 1
fi

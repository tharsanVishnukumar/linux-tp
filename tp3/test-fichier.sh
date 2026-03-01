#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Vous devez fournir exactement 1 argument"
  exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
  echo "Le fichier $1 n'existe pas."
  exit 1
fi

if [ -d "$FILE" ]; then
  echo "Le fichier $1 est un répertoire."
elif [ -f "$FILE" ]; then
  if [ -s "$FILE" ]; then
    echo "Le fichier $FILE est un fichier ordinaire et il n'est pas vide."
  else
    echo "Le fichier $FILE est un fichier ordinaire et il est vide."
  fi
else
  echo "Le fichier $FILE est d'un autre type"
fi

PERMS=""
USER=$(whoami)

if [ -r "$FILE" ]; then
  PERMS="lecture"
fi

if [ -w "$FILE" ]; then
  PERMS="$PERMS écriture"
fi

if [ -x "$FILE" ]; then
  PERMS="$PERMS exécution"
fi
echo "\"$FILE\" est accessible par $USER en $PERMS"

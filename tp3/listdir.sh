#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Vous devez fournir exactement 1 argument"
  exit 1
fi

DIR="$1"

echo "####### fichier dans $DIR/"
find "$DIR" -maxdepth 1 -type f

echo "####### repertoires dans $DIR/"
find "$DIR" -maxdepth 1 -type d ! -path "$DIR"

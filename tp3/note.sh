#!/bin/bash

while true; do
  read -p "Saisissez une note sur 20 (ou appuyez sur 'q' pour quitter) : " note

  if [[ "$note" == "q" ]]; then
    echo "Fermeture du programme."
    break
  fi

  if ! [[ "$note" =~ ^[0-9]+$ ]]; then
    echo "Erreur : Veuillez entrer un nombre entier valide ou 'q'."
    continue
  fi

  if [ "$note" -ge 16 ] && [ "$note" -le 20 ]; then
    echo "très bien"
  elif [ "$note" -ge 14 ] && [ "$note" -lt 16 ]; then
    echo "bien"
  elif [ "$note" -ge 12 ] && [ "$note" -lt 14 ]; then
    echo "assez bien"
  elif [ "$note" -ge 10 ] && [ "$note" -lt 12 ]; then
    echo "moyen"
  elif [ "$note" -ge 0 ] && [ "$note" -lt 10 ]; then
    echo "insuffisant"
  else
    echo "Note invalide. La note doit être comprise entre 0 et 20."
  fi
done

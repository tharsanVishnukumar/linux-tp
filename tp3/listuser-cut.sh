#!/bin/bash

for ligne in $(cut -d: -f1,3 /etc/passwd); do
  nom=$(echo "$ligne" | cut -d: -f1)
  uid=$(echo "$ligne" | cut -d: -f2)

  if [ "$uid" -gt 100 ]; then
    echo "$nom"
  fi
done

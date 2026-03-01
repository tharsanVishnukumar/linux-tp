#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Vous devez fournir exactement 2 arguments"
  exit 1
fi

echo "$1$2"

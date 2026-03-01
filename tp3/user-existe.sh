#!/bin/bash

if [ -z "$1" ]; then
  exit 1
fi

getent passwd "$1" | cut -d: -f3

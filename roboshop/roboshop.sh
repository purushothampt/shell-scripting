#! /bin/bash

if [! -e components/$1.sh]; then
  echo "Component file does not exist"
fi
bash components/$1.sh
